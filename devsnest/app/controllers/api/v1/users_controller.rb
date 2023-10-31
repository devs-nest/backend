# frozen_string_literal: true

module Api
  module V1
    class UsersController < ApplicationController
      include JSONAPI::ActsAsResourceController
      include ApplicationHelper
      before_action :simple_auth, only: %i[report]
      before_action :bot_auth, only: %i[left_discord create index get_token update_discord_username check_group_name check_user_detais]
      before_action :user_auth,
                    only: %i[logout me update connect_discord onboard markdown_encode upload_files email_verification_initiator dashboard_details create_github_commit connect_github
                             create_github_repo repo_details sourcecode_io leaderboard github_data add_repo remove_repo]
      before_action :update_college, only: %i[update onboard]
      before_action :update_username, only: %i[update]
      before_action :is_github_connected, only: %i[github_data add_repo remove_repo]
      before_action :validate_phone_number, only: %i[send_otp verify_phone_number]

      def context
        { user: @current_user }
      end

      def me
        @current_user.update(login_count: @current_user.login_count + 1) if @current_user.login_count < 3
        redirect_to api_v1_user_url(@current_user)
      end

      def get_by_username
        user = User.find_by(username: params[:id])
        return render_not_found unless user.present?

        redirect_to api_v1_user_url(user)
      end

      def get_token
        discord_id = params['data']['attributes']['discord_id']
        user = User.find_by(discord_id: discord_id)
        return render_success({ id: user.id, type: 'bot_token', bot_token: user.bot_token }) if user.present?

        render_error('User not found')
      end

      def report
        if @current_user.present?
          user = @current_user
        elsif @bot.present?
          discord_id = params[:discord_id]
          user = User.find_by(discord_id: discord_id)
          return render_error('User not found') if user.nil?
        end
        days = params[:days].to_i || nil
        res = Submission.user_report(days, user.id)
        render_success({ id: user.id, type: 'report' }.merge(res))
      end

      def leaderboard
        course_type = params[:course_type]
        course_timeline = params[:course_timeline]
        return render_error({ message: 'Course type must be dsa or frontend' }) if LeaderboardDevsnest::COURSE_TYPE.values.exclude?(course_type)

        return render_error({ message: 'Course timeline must be weekly or monthly' }) if LeaderboardDevsnest::COURSE_TIMELINE.values.exclude?(course_timeline)

        leaderboard = course_type == LeaderboardDevsnest::COURSE_TYPE[:DSA] ? @dsa_leaderboard : @fe_leaderboard
        if leaderboard.check_member?(@current_user.username).blank?
          leaderboard.rank_member(@current_user.username,
                                  LeaderboardDevsnest::COURSE_TYPE[:DSA] ? @current_user.score : @current_user.fe_score)
        end
        leaderboard.page_size = params[:size].to_i || 10
        page = params[:page].to_i
        leaderboard_copy = LeaderboardDevsnest::CopyLeaderboard.new(course_type, course_timeline).call
        scoreboard = []

        leaderboard.leaders(page).each do |data|
          prev_rank = leaderboard_copy.rank_for(data[:name])
          rank_change = prev_rank != 0 ? prev_rank - data[:rank] : prev_rank
          scoreboard.push(data.merge(rank_change: rank_change))
        end

        data = {
          id: page,
          type: "#{course_type}_#{course_timeline}_leaderboard",
          current_user: @current_user.lb_data(leaderboard, leaderboard_copy),
          scoreboard: scoreboard,
          count: leaderboard.total_pages
        }
        render_success(data)
      end

      def create
        discord_id = params['data']['attributes']['discord_id']
        user = User.find_by(discord_id: discord_id)
        if user
          user.discord_active = true
          user.save
          return render_success(user.as_json.merge({ "type": 'users', status: 'status updated' }))
        end
        super
      end

      def left_discord
        discord_id = params['data']['attributes']['discord_id']
        user = User.find_by(discord_id: discord_id)
        user.discord_active = false
        user.save
        render_success(user.as_json.merge({ "type": 'users', status: 'status updated' }))
      end

      def logout
        render_success(id: @current_user.id, type: 'logout', notice: 'You logged out successfully')
      end

      def connect_discord
        return render_error({ message: 'Please Connect with Discord or enter bot-token' }) unless params['code'].present? || params['data']['attributes']['bot_token'].present?

        if params['code'].present?
          discord_id = User.fetch_discord_id(params['code'])
          return render_error({ message: 'Incorrect code from discord' }) if discord_id.nil?

          temp_user = User.find_by(discord_id: discord_id)
          if temp_user.nil?
            @current_user.update(discord_id: discord_id, discord_active: true)
            return render_success(@current_user.as_json.merge({ "type": 'users' }))
          end
        else
          temp_user = User.find_by(bot_token: params['data']['attributes']['bot_token'])
          return render_error({ message: 'Could Not find User of Provided token' }) if temp_user.nil?
        end
        return render_error({ message: 'Discord user is already connected to another user' }) if temp_user.web_active?

        @current_user.merge_discord_user(temp_user.discord_id, temp_user)
        render_success(@current_user.as_json.merge({ "type": 'users' }))
      end

      def connect_github
        permitted_params = params.permit(%i[code]).to_h
        return render_error({ message: 'Github Access Code not found' }) unless permitted_params['code'].present?

        res = User.fetch_github_access_token(permitted_params['code'])
        if res.key?(:access_token)
          data_to_encode = {
            user_id: @current_user.id,
            access_token: res[:access_token],
            initiated_at: Time.now
          }
          encrypted_access_token = $cryptor.encrypt_and_sign(data_to_encode)
          @current_user.update!(github_token: encrypted_access_token)
          render_success({ message: 'Github connected successfully!' })
        else
          render_error({ error: res[:error] })
        end
      end

      def create_github_repo
        permitted_params = params.permit(%i[repo_name]).to_h
        repo_name = permitted_params[:repo_name]
        client = @current_user.github_client
        return render_error({ message: 'Github Not connected!' }) if client.blank?

        begin
          client.create_repository(repo_name, private: true, auto_init: true)
        rescue StandardError
          return render_error({ message: 'Something went wrong' })
        end

        render_success({ message: 'Repo created Successfully!' })
      end

      def login
        code = params['code']
        return render_error({ message: 'code parameter not specified or invalid login method' }) if !code && params['login_method'] != 'manual'

        if params['login_method'] == 'manual'
          user = User.find_by_email(params['email'])
          return render_error({ message: 'Invalid password or username' }) unless user&.valid_password?(params[:password])
        else
          user = User.fetch_google_user(code, params)
        end

        user.update!(is_college_student: true) if params['is_college_student'] == true && user.is_college_student == false

        if user.present?
          sign_in(user)
          set_current_user
          colleges = user.college_profile.includes(:college).collect { |cps| {
              id: cps.college&.id,
              slug: cps.college&.slug,
              name: cps.college&.name
            }
          }

          return render_success(user.as_json.merge({ "type": 'users', "colleges": colleges })) if @current_user.present?
        end
        render_error({ message: 'Error occured while authenticating' })
      end

      def college_login
        user = CollegeProfile.find_by_email(params['email'])&.user
        return render_error({ message: 'Invalid password or username' }) unless user&.valid_password?(params[:password])

        if user.present?
          sign_in(user)
          set_current_college_user
          return render_success(user.as_json.merge({ "type": 'college_user', "college_id": user.college.id })) if @current_college_user.present?
        end
        render_error({ message: 'Error occured while authenticating college user' })
      end

      def update_college
        college_name = params['data']['attributes']['college_name']
        unless college_name.present?
          params['data']['attributes'].delete 'college_name'
          return true
        end
        College.create_college(college_name) unless College.exists?(name: college_name)
        params['data']['attributes']['college_id'] = College.find_by(name: college_name).id
        params['data']['attributes'].delete 'college_name'
      end

      def update_username
        return render_unauthorized unless @current_user.id.to_s == params['data']['id']
        return true if params['data']['attributes']['username'].nil? || context[:user].username == params['data']['attributes']['username']

        return render_error({ message: 'Username pattern mismatched' })  if check_username(params['data']['attributes']['username'])

        return render_error({ message: 'User already exists' }) if User.find_by(username: params['data']['attributes']['username']).present?

        if context[:user].update_count >= 4
          render_error({ message: 'Update count Exceeded for username' })
        else
          @dsa_leaderboard.remove_member(context[:user].username)
          @fe_leaderboard.remove_member(context[:user].username)
          LeaderboardDevsnest::COURSE_TYPE.each_value do |course_type|
            LeaderboardDevsnest::COURSE_TIMELINE.each_value do |course_timeline|
              lb = LeaderboardDevsnest::CopyLeaderboard.new(course_type, course_timeline).call
              prev_score = lb.score_for(context[:user].username)
              lb.remove_member(context[:user].username)
              lb.rank_member(params['data']['attributes']['username'], prev_score)
            end
          end
          Challenge.rerank_member(context[:user], params['data']['attributes']['username'])
          params['data']['attributes']['update_count'] = context[:user].update_count + 1
        end
      end

      def onboard
        updatable_params = params.require(:data).permit(attributes: %i[
                                                          discord_username discord_id name work_exp known_from grad_year
                                                          dsa_skill webd_skill is_discord_form_filled college_id
                                                        ])
        return render_error({ message: 'Discord form already filled' }) if @current_user.is_discord_form_filled

        return render_error({ message: "Discord isn't connected" }) unless @current_user.discord_active

        return render_error({ message: 'User already in a group' }) if GroupMember.find_by(user_id: @current_user.id)

        @current_user.update!(updatable_params[:attributes])
        render_success({ message: 'Form filled' })
      end

      def update_discord_username
        user = User.find_by(discord_id: params['data']['attributes']['discord_id'])

        return render_error({ message: 'User does not exist' }) if user.nil?

        user.update(discord_username: params['data']['attributes']['discord_username'])
        render_success(user.as_json.merge({ "type": 'users' }))
      end

      def certifications
        user = User.find_by(id: params['id'])
        if user.present?
          render_success({ id: user.id, type: 'certifications', certificates: user.certifications })
        else
          render_not_found
        end
      end

      def upload_files
        return unless params['file_upload'].present? && (params['file_upload_type'] == 'profile-image' || params['file_upload_type'] == 'resume')

        type = params['file_upload_type']
        file = params['file_upload']
        mime = User.mime_types_s3(type)
        threshold_size = type == 'profile-image' ? 4_194_304 : 5_242_880
        return render_error('Unsupported format') unless mime.include? file.content_type
        return render_error('File size too large') if request.headers['content-length'].to_i > threshold_size

        key = "#{@current_user.id}/#{SecureRandom.hex(8)}_#{type}"
        User.upload_file_s3(file, key, type)
        update_link = type == 'profile-image' ? 'image_url' : 'resume_url'

        bucket = "https://#{ENV['S3_PREFIX']}#{type}.s3.amazonaws.com/"

        public_link = bucket + key
        @current_user.update("#{update_link}": public_link)

        api_render(200, { id: key, type: type, user_id: @current_user.id, bucket: "devsnest-#{type}", public_link: public_link })
      end

      def register
        return render_error({ message: 'Password not matched' }) if params[:password] != params[:password_confirmation]

        user = User.find_by_email(params[:email])
        return render_error({ message: 'User already exists!' }) if user.present?

        referral_code = params[:referral_code]
        params.delete(:referral_code)
        user = User.new(sign_up_params)
        user.web_active = true
        if user.save
          referred_by = User.find_by_referral_code(referral_code)
          if referred_by.present? && referred_by.id != user.id && referred_by.is_college_student?
            referral_type = params[:is_college_student] ? 1 : 0
            Referral.create(referral_code: referral_code, referred_user_id: user.id, referral_type: referral_type, referred_by: referred_by.id)
            template_id = EmailTemplate.find_by(name: 'referral_notifier')&.template_id
            EmailSenderWorker.perform_async(referred_by.email, { 'username': referred_by.name, 'reffered_username': user.name, 'unsubscribe_token': user.unsubscribe_token }, template_id)
          end
          sign_in(user)
          set_current_user
          render json: user if @current_user.present?
        else
          render_error(user.errors.to_s)
        end
      end

      def reset_password_initiator
        user = User.find_by_email(params[:email])

        return render_error({ message: 'No user exists with this e-mail' }) if user.nil?

        data_to_encode = {
          user_id: user.id,
          initiated_at: Time.now
        }
        last_query = user.manual_login_changelog.order('created_at').where(query_type: 'password_reset').last

        return render_error({ message: 'You must wait 24hr before submitting another request' }) if last_query.present? && last_query.within_a_day?

        encrypted_code = $cryptor.encrypt_and_sign(data_to_encode)
        ManualLoginChangelog.create(user_id: user.id, uid: encrypted_code, query_type: 'password_reset')

        UserMailer.password_reset(user, encrypted_code).deliver_later
        render_success({ message: 'An email has been sent to you with detailed instruction, Check your Inbox!' })
      end

      def reset_password
        return render_error({ message: 'Invalid Link!' }) if params[:uid].nil?

        query = ManualLoginChangelog.where(uid: params[:uid], query_type: 'password_reset').first
        return render_error({ message: 'The link has been expired!' }) if query.nil? || query&.is_fulfilled == true

        decoded_data = $cryptor.decrypt_and_verify(params[:uid])

        user = User.get_by_cache(decoded_data[:user_id])
        user.update(password: params[:password])
        query.update(is_fulfilled: true)

        render_success({ message:  'Password updated!' })
      end

      def email_verification_initiator
        return render_error({ message: 'User already verified' }) if @current_user.is_verified

        data_to_encode = {
          user_id: @current_user.id,
          initiated_at: Time.now
        }
        last_query = @current_user.manual_login_changelog.order('created_at').where(query_type: 'verification').last
        return render_error({ message: 'You must wait 24hr before submitting another request' }) if last_query.present? && last_query.within_a_day?

        encrypted_code = $cryptor.encrypt_and_sign(data_to_encode)
        ManualLoginChangelog.create(user_id: @current_user.id, uid: encrypted_code, query_type: 'verification')

        UserMailer.verification(@current_user, encrypted_code).deliver_later
        render_success({ message: 'An email has been sent to you, Check your Inbox!' })
      end

      def email_verification
        return render_error({ message: 'Invalid Link!' }) if params[:uid].nil?

        query = ManualLoginChangelog.where(uid: params[:uid], query_type: 'verification').first
        return render_error({ message: 'The link has been expired!' }) if query.nil? || query&.is_fulfilled == true

        decoded_data = $cryptor.decrypt_and_verify(params[:uid])

        user = User.get_by_cache(decoded_data[:user_id])

        user.update(is_verified: true)
        query.update(is_fulfilled: true)
        render_success({ message:  'User verified successfully' })
      end

      def unsubscribe
        return render_error({ message: 'Invalid Link!' }) if params[:token].nil?

        decoded_data = JWT.decode(params[:token], Rails.application.secrets.secret_key_base || '')[0]

        Unsubscribe.create!(user_id: decoded_data['user_id'], category: params[:category]) unless Unsubscribe.find_by(user_id: decoded_data['user_id'], category: params[:category]).present?

        render_success({ message: 'Unsubscribed Successfully' })
      end

      def upload_i_have_enrolled_for_course_image
        user = @current_user
        file = params['image-file']
        file_name = SecureRandom.hex(5)
        key = "#{file_name}_#{user.id}"
        $s3&.put_object(bucket: "#{ENV['S3_PREFIX']}custom-images", key: key, body: file)
        image_link = "https://#{ENV['S3_PREFIX']}custom-images.s3.amazonaws.com/#{key}"
        user.update(enrolled_for_course_image_url: image_link)
        render_success({ message: 'Image uploaded successfully' })
      end

      def check_group_name
        discord_id = params.dig(:data, :attributes, 'discord_id')
        user = User.find_by(discord_id: discord_id)
        groupmember = user.present? ? GroupMember.find_by(user_id: user.id) : nil

        return render_error({ message: 'No group found' }) if groupmember.nil?

        render_success({ name: groupmember.group.name, server_guild_id: groupmember.group&.server&.guild_id })
      end

      def check_user_details
        discord_ids = params.dig(:data, :attributes, 'discord_ids')
        return render_error({ message: 'No discord_ids provided' }) if discord_ids.nil? || discord_ids.empty?

        users = User.where(discord_id: discord_ids)
        return render_error({ message: 'Users not found' }) if users.empty?

        data = []
        users.each do |user|
          user_details = get_user_details(user)
          data << user_details
        end

        render_success({ user_details: data })
      end

      def create_github_commit
        repo = params.dig(:data, :attributes, 'repo')
        secrets = params.dig(:data, :attributes, 'secrets')
        commited_files = params.dig(:data, :attributes, 'commited_files')
        commit_message = params.dig(:data, :attributes, 'commit_message')
        GithubCommitWorker.perform_async(@current_user.id, repo, secrets.to_json, commited_files.to_json, commit_message)

        render_success({ message: 'Committed :D' })
      end

      def sourcecode_io
        table_name = ''
        bucket = ''
        challenge_type = params.dig(:data, :attributes, 'challenge_type')

        case challenge_type
        when 'backend'
          table_name = BackendChallenge
          bucket = 'user-be-submission'
        when 'frontend'
          table_name = FrontendChallenge
          bucket = 'user-fe-submission'
        else
          return render_not_found('challenge_type')
        end

        challenge = table_name.find_by(id: params.dig(:data, :attributes, 'challenge_id'))
        return render_not_found('challenge') if challenge.nil?

        files = params.dig(:data, :attributes, 'files')
        action = params.dig(:data, :attributes, 'action')
        base_path = "#{@current_user.id}/#{challenge.id}"
        io_boilerplate(files, base_path, bucket, action)
        render_success({ message: 'Updated Last submission' })
      end

      # Ex:- :default =>''
      def dashboard_details
        user = @current_user
        return render_not_found({ message: 'User not found' }) if user.blank?

        data = {
          accepted_in_course: user.accepted_in_course, # To distinguish from old user vs new user
          discord_active: user.discord_active, # To distinguish from connedted vs not connected user
          is_fullstack_course_22_form_filled: user.is_fullstack_course_22_form_filled, # To distinguish from users filled up the form or not
          group_details: user.group_details, # To get the group details
          total_by_difficulty: Challenge.split_by_difficulty, # Algo Challenges Details
          solved: Challenge.count_solved(user.id), # Algo Challenges Details
          tha_details: user.tha_details, # Bootcamp Progress
          leaderboard_details: user.leaderboard_details('dsa'), # Leaderboard Details
          fe_solved: FrontendChallenge.count_solved(user.id),
          fe_total_by_topic: FrontendChallenge.split_by_topic,
          fe_leaderboard_details: user.leaderboard_details('frontend'),
          bootcamp_progress_details: user.bootcamp_progress_details
        }
        render_success(data.as_json)
      end

      def github_ping
        github_connected = begin
          @current_user.github_client.login
        rescue StandardError
          false
        end
        github_connected.present? ? render_success : render_error({ message: 'Github not connected.' })
      end

      def repo_files
        client = @current_user.github_client

        render_success({ file_names: client.contents("#{client.login}/#{params[:repo_name]}").pluck(:name) })
      end

      def disconnect_user
        user = User.find_by(id: params.dig(:data, :attributes, 'id'))

        return render_unauthorized unless user.id == @current_user.id
        return render_error(message: 'Can\'t decouple the user') unless user.discord_active && user.web_active

        user.un_merge_discord_user
        render_success({ message: 'User is decoupled!' })
      end

      def add_repo
        repo_name = params.dig(:data, :attributes, :repository_name)
        return render_error({ message: 'Repository does not exist' }) if GithubDataHelper.does_repository_exists(@current_user.github_client.login, repo_name)

        return render_error({ message: 'Repository already added' }) if @current_user.github_repos.include?(repo_name)

        @current_user.github_repos << repo_name
        @current_user.save!
        render_success({ message: 'Repository Added' })
      end

      def remove_repo
        repo_name = params.dig(:data, :attributes, :repository_name)
        return render_error({ message: 'Repository does not exist' }) if @current_user.github_repos.exclude?(repo_name)

        @current_user.github_repos.delete(repo_name)
        @current_user.save!
        render_success({ message: 'Repository Removed' })
      end

      def send_otp
        return render_error({ message: 'Phone Number Already Used.' }) if params[:verification_type] == 'college_registration' && CollegeStudent.find_by_phone(@phone_number).present?

        otp_log = OtpLog.find_by_phone_number(@phone_number)
        if otp_log.present?
          time_till_next_otp = (Time.zone.now.to_i - (otp_log.updated_at.to_i + otp_log.timeout.minutes.to_i))
          return render_error({ message: "Please Wait for #{remaining_time_label(time_till_next_otp.abs)} before sending another OTP." }) unless time_till_next_otp.positive?
        end

        otp = SecureRandom.random_number(1_000_000).to_s.rjust(6, '0')
        code, response_body = send_otp_service(@phone_number, otp)

        if code == 200
          otp_log = OtpLog.create(phone_number: @phone_number, request_count: 0, timeout: 1) if otp_log.blank?
          if otp_log.request_count == 3
            otp_log.update(request_count: 1, timeout: 1)
          else
            otp_log.update(request_count: otp_log.request_count + 1, timeout: otp_log.request_count == 2 ? 30 : 1)
          end
          Rails.cache.write("otp_#{@phone_number}", otp, expires_in: 2.minutes)
          render_success({ message: 'OTP Sent.' })
        else
          render_error({ message: response_body['message'].first })
        end
      end

      def verify_phone_number
        generated_otp = Rails.cache.fetch("otp_#{@phone_number}")
        input_otp = params[:otp]
        return render_error({ message: 'Invalid OTP.' }) if generated_otp != input_otp

        if params[:verification_type] == 'college_registration'
          student = CollegeStudent.find_by_id(params[:student_id])
          student&.update(phone: @phone_number, phone_verified: true, state: 'fill_pd')
        else
          enquiry = CollegeEnquiry.find_by_phone_number(@phone_number)
          if enquiry.present?
            enquiry.update(enquiry_count: enquiry.enquiry_count + 1)
          else
            CollegeEnquiry.create!(phone_number: @phone_number, enquiry_count: 1)
          end
        end

        template_id = EmailTemplate.find_by(name: 'phone_number_verified')&.template_id
        EmailSenderWorker.perform_async(@current_user.email, { 'username': @current_user.name, 'unsubscribe_token': @current_user.unsubscribe_token }, template_id)
        render_success({ message: 'Phone Number Verified.' })
      end

      private

      def sign_up_params
        params.permit(:email, :password, :password_confirmation, :name, :is_college_student)
      end

      def is_github_connected
        github_connected = begin
          @current_user.github_client.login
        rescue StandardError
          nil
        end
        return render_error({ message: 'Github not connected.' }) if github_connected.nil?
      end

      def validate_phone_number
        @phone_number = params[:phone_number]
        return render_error({ message: 'Invalid Phone Number.' }) unless valid_phone_number?(@phone_number)
      end
    end
  end
end
