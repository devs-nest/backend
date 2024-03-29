# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                                 :bigint           not null, primary key
#  accepted_in_course                 :boolean          default(FALSE)
#  batch                              :string(255)
#  be_score                           :integer          default(0)
#  bio                                :string(255)      default("")
#  bot_token                          :string(255)
#  buddy                              :integer          default(0)
#  coins                              :integer          default(0)
#  college_name                       :string(255)
#  college_year                       :integer
#  company_name                       :string(255)
#  discord_active                     :boolean          default(FALSE)
#  discord_username                   :string(255)
#  dn_airtribe_student                :boolean          default(FALSE)
#  dob                                :date
#  dsa_skill                          :integer          default(0)
#  dsa_streak                         :integer          default(0)
#  email                              :string(255)      default(""), not null
#  encrypted_password                 :string(255)      default(""), not null
#  enrolled_for_course_image_url      :string(255)
#  fe_score                           :integer          default(0)
#  github_repos                       :text(65535)
#  github_token                       :text(65535)
#  github_url                         :string(255)
#  grad_end                           :integer
#  grad_specialization                :string(255)
#  grad_start                         :integer
#  grad_status                        :string(255)
#  grad_year                          :integer
#  group_assigned                     :boolean          default(FALSE)
#  image_url                          :string(255)      default("")
#  is_college_form_filled             :boolean          default(FALSE)
#  is_college_student                 :boolean          default(FALSE)
#  is_discord_form_filled             :boolean          default(FALSE)
#  is_fullstack_course_22_form_filled :boolean          default(FALSE)
#  is_verified                        :boolean          default(FALSE)
#  kind                               :integer          default(0)
#  known_from                         :string(255)
#  last_dsa_streak                    :integer          default(0)
#  linkedin_url                       :string(255)
#  login_count                        :integer          default(0)
#  markdown                           :text(65535)
#  name                               :string(255)      default("")
#  phone_number                       :string(255)
#  previously_joined_a_group          :boolean          default(FALSE)
#  provider                           :string(255)
#  referral_code                      :string(255)
#  registration_num                   :string(255)
#  remember_created_at                :datetime
#  reset_password_sent_at             :datetime
#  reset_password_token               :string(255)
#  resume_url                         :string(255)
#  role                               :integer
#  school                             :string(255)
#  score                              :float(24)        default(0.0)
#  streak_end_date                    :date
#  update_count                       :integer          default(0)
#  user_type                          :integer          default("user")
#  username                           :string(255)      default(""), not null
#  web_active                         :boolean          default(FALSE)
#  webd_skill                         :integer          default(0)
#  work_exp                           :string(255)
#  working_role                       :string(255)
#  working_status                     :string(255)
#  created_at                         :datetime         not null
#  updated_at                         :datetime         not null
#  bot_id                             :integer
#  college_id                         :integer
#  discord_id                         :string(255)      default(""), not null
#  google_id                          :string(255)
#  listmonk_subscriber_id             :integer
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_username              (username) UNIQUE
#
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :jwt_authenticatable,
         jwt_revocation_strategy: JwtBlacklist
  after_create :create_bot_token
  enum user_type: %i[user admin problem_setter college_admin]
  after_create :create_username
  validates_uniqueness_of :username, case_sensitive: true
  validates_uniqueness_of :referral_code, case_sensitive: true
  validates :dob, inclusion: { in: (Date.today - 60.years..Date.today) }, allow_nil: true
  belongs_to :college, optional: true
  has_many :internal_feedbacks
  has_many :frontend_projects, dependent: :delete_all
  has_many :unsubscribes, dependent: :delete_all
  has_many :algo_submissions
  has_many :run_submissions
  has_many :challenges
  has_many :frontend_challenges
  has_many :minibootcamp_submissions
  has_many :certifications, dependent: :delete_all
  has_many :manual_login_changelog
  has_many :user_challenge_scores
  has_many :room_best_submissions
  has_many :frontend_challenge_scores
  has_many :coin_logs
  has_many :job_applications
  has_many :article_submissions
  has_many :backend_challenges
  has_many :backend_challenge_scores
  has_many :bootcamp_progresses
  has_many :coding_rooms
  has_many :college_profile
  has_one :user_integration
  has_many :event_registrations
  has_many :edu_events, through: :event_registrations
  has_one :college_student, dependent: :destroy

  has_many :user_skills
  has_many :skills, through: :user_skills
  has_many :group_members, dependent: :delete_all
  has_many :user_article_activities, dependent: :destroy

  # delegate :college, to: :college_profile, allow_nil: true

  before_save :markdown_encode, if: :will_save_change_to_markdown?
  after_create :assign_bot_to_user, :add_user_to_listmonk
  # after_create :send_registration_email
  after_update :send_step_one_mail
  after_update :send_step_two_mail_if_discord_active_false
  after_update :update_user_coins_for_signup
  after_update :update_user_score_lb, if: :saved_change_to_score?
  after_update :update_user_fe_score_lb, if: :saved_change_to_fe_score?

  after_create :create_college_student
  after_update :create_college_student, if: :saved_change_to_is_college_student?
  after_save :manage_list, if: proc { !Rails.env.test? && ENV['LISTMONK_LIST_CONTROL'] == 'true' }
  before_validation :create_referral_code, if: :is_referall_empty?
  after_save :expire_dashboard_cache, if: :saved_change_to_name?
  serialize :github_repos, Array
  has_paper_trail

  def update_user_fe_score_lb
    fe_lb = LeaderboardDevsnest::FEInitializer::LB
    fe_lb.rank_member(username, fe_score)
  end

  def update_user_score_lb
    main_lb = LeaderboardDevsnest::DSAInitializer::LB
    main_lb.rank_member(username, score || 0)
  end

  def manage_list
    changes = saved_changes
    $listmonk.list_control(changes, self)
  end

  def create_username
    username = ''
    count = 0
    temp = email.split('@')[0].gsub(/[^0-9A-Za-z]/, '')
    username = (count += 1).to_s while User.find_by(username: temp + username)
    update_attribute(:username, temp + username)
  end

  def is_referall_empty?
    referral_code.blank?
  end

  def assign_bot_to_user
    update_attribute(:bot_id, rand(1..20))
  end

  def create_referral_code
    Rails.logger.info 'Retrying referral code generation' while update(referral_code: "#{name&.first(3)&.upcase}#{SecureRandom.hex(3).upcase}") == false
  end

  def self.fetch_discord_id(code)
    token = fetch_discord_access_token(code)
    return if token.nil?

    user_details = fetch_discord_user_details(token)
    return if user_details.nil?

    user_details['id']
  end

  def self.fetch_google_user(code, params)
    referral_code = params[:referral_code] || ''
    user_details = fetch_google_user_details(code)
    return if user_details.nil?

    # Checking referral flow once only on user creation
    present_user = User.find_by(email: user_details['email'])
    user = create_google_user(user_details, referral_code)
    referred_by = User.find_by_referral_code(referral_code)
    if !present_user.present? && referred_by.present? && referred_by.is_college_student?
      referral_type = params[:is_college_student] ? 1 : 0
      Referral.create(referral_code: referral_code, referred_user_id: user.id, referral_type: referral_type, referred_by: referred_by.id)
      template_id = EmailTemplate.find_by(name: 'referral_notifier')&.template_id
      EmailSenderWorker.perform_async(referred_by.email, { 'username': referred_by.name, 'reffered_username': user.name, 'unsubscribe_token': user.unsubscribe_token }, template_id)

    end
    user
  end

  def self.fetch_google_user_details(code)
    response = HTTParty.get('https://www.googleapis.com/oauth2/v3/userinfo', headers: { Authorization: "Bearer #{code}" })
    JSON.parse(response.body)
  end

  def self.create_google_user(user_details, _referral_code = '')
    email = user_details['email']
    name = user_details['name']
    google_id = user_details['sub'] # We are receiving google_id in the 'sub' key from google
    user = User.where(email: email).first
    avatar = nil
    avatar = user_details['picture'] if user_details['picture'].present?
    if user.present?
      user.update(web_active: true, google_id: google_id)
      return user
    end

    user = User.create!(
      name: name,
      email: email,
      password: Devise.friendly_token[0, 20],
      web_active: true,
      image_url: avatar,
      google_id: google_id,
      is_verified: true
    )

    # Accept all college invitations
    college_profile = CollegeProfile.find_by(email: email)

    return user if college_profile.blank?

    college_invites = CollegeInvite.where(college_profile_id: college_profile.id)
    college_invites.update_all(status: 1)

    user
  end

  def merge_discord_user(discord_id, discord_user)
    update(discord_id: discord_id, discord_active: true)

    group = GroupMember.find_by(user_id: id)&.group
    RoleModifierWorker.perform_async('add_role', discord_id, group.name, group.server&.guild_id) if group.present? # Giving group role to newly added discord id

    ServerUser.where(user_id: id, active: true).each do |server_user| # Giving other roles
      server = Server.find_by(id: server_user.server_id)
      RoleModifierWorker.perform_async('add_role', discord_id, 'Verified', server.guild_id)
      RoleModifierWorker.perform_async('add_role', discord_id, 'DN JUNE BATCH', server.guild_id)
    end

    return unless discord_user.present?

    ServerUser.where(user_id: discord_user.id).update_all(user_id: id)
    discord_user.destroy
  end

  def un_merge_discord_user
    new_discord_id = discord_id
    self.paper_trail_event = 'disconnect_user'
    update(discord_id: '', discord_active: false)

    group = GroupMember.find_by(user_id: id)&.group
    RoleModifierWorker.perform_async('delete_role', new_discord_id, group.name, group.server&.guild_id) if group.present? # Removing role from old user

    ServerUser.where(user_id: id, active: true).each do |server_user| # Removing other roles
      server = Server.find_by(id: server_user.server_id)
      RoleModifierWorker.perform_async('delete_role', new_discord_id, 'Verified', server.guild_id)
      RoleModifierWorker.perform_async('delete_role', new_discord_id, 'DN JUNE BATCH', server.guild_id)
    end
    discord_user = User.find_by(discord_id: new_discord_id)
    discord_user = User.create!(name: name, username: new_discord_id, email: "#{new_discord_id}@gmail.com", discord_id: new_discord_id, discord_active: true) unless discord_user.present?

    ServerUser.where(user_id: id).update_all(user_id: discord_user.id) if discord_user.present?
  end

  def self.fetch_discord_access_token(code)
    url = URI('https://discordapp.com/api/oauth2/token')
    token = "Basic #{Base64.strict_encode64("#{ENV['DISCORD_CLIENT_ID']}:#{ENV['DISCORD_CLIENT_SECRET']}")}"

    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    request = Net::HTTP::Post.new(url)

    request['Authorization'] = token
    request['Content-Type'] = 'application/x-www-form-urlencoded'
    request.body = "code=#{code}&grant_type=authorization_code&redirect_uri=#{ENV['DISCORD_REDIRECT_URI']}"
    response = https.request(request)
    response.code == '200' ? JSON(response.read_body)['access_token'] : nil
  end

  def self.fetch_github_access_token(code)
    url = URI('https://github.com/login/oauth/access_token')

    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    request = Net::HTTP::Post.new(url)

    request.body = "code=#{code}&client_id=#{ENV['GITHUB_CLIENT_ID']}&client_secret=#{ENV['GITHUB_CLIENT_SECRET']}"
    response = https.request(request)
    json_response_body = Rack::Utils.parse_nested_query(response.body)
    return unless response.code == '200'

    if json_response_body.key?('access_token')
      { 'access_token': json_response_body['access_token'] }
    else
      { 'error': json_response_body['error'] }
    end
  end

  def self.fetch_discord_user_details(token)
    url = 'http://discordapp.com/api/users/@me'
    headers = {
      'Content-Type' => 'application/json',
      Authorization: "Bearer #{token}"
    }

    response = HTTParty.post(url, body: {}, headers: headers)
    response.code == 200 ? JSON(response.read_body) : nil
  end

  def fetch_group_ids
    case user_type
    when 'user'
      Group.where(batch_leader_id: id).pluck(:id) + GroupMember.where(user_id: id).pluck(:group_id)
    when 'admin'
      Group.all.ids
    end
  end

  def create_bot_token
    update(bot_token: Digest::SHA1.hexdigest([Time.now, rand].join))
  end

  def self.to_csv
    attributes = %w[id discord_username discord_id name grad_year school work_exp known_from dsa_skill webd_skill]

    CSV.generate(headers: true) do |csv|
      csv << attributes
      all.each do |user|
        csv << attributes.map { |attr| user.send(attr) }
      end
    end
  end

  # Use this to create or reload the redis sorted set
  def self.initialize_leaderboard
    dsa_lb = LeaderboardDevsnest::DSAInitializer::LB
    fe_lb = LeaderboardDevsnest::FEInitializer::LB

    dsa_lb.delete_leaderboard
    fe_lb.delete_leaderboard

    User.where(accepted_in_course: true).find_each.pluck(:username, :score, :fe_score).each do |user|
      dsa_lb.rank_member(user[0], user[1])
      fe_lb.rank_member(user[0], user[2])
    end

    LeaderboardDevsnest::COURSE_TYPE.each_value do |course_type|
      LeaderboardDevsnest::COURSE_TIMELINE.each_value do |course_timeline|
        lb_copy = LeaderboardDevsnest::CopyLeaderboard.new(course_type, course_timeline).call
        lb = course_type == LeaderboardDevsnest::COURSE_TYPE[:DSA] ? dsa_lb : fe_lb
        lb_copy.delete_leaderboard

        (1..lb.total_pages).each do |n|
          lb.leaders(n).each do |data|
            lb_copy.rank_member(data[:name], data[:score])
          end
        end
      end
    end
  end

  def markdown_encode
    self.markdown = markdown.dup.force_encoding('ISO-8859-1').encode('UTF-8') unless markdown.blank?
  end

  def self.upload_file_s3(file, key, type)
    $s3.put_object(bucket: ENV['S3_PREFIX'] + type, key: key, body: file)
  end

  def self.mime_types_s3(type)
    mimes = {
      'profile-image' => %w[image/png image/jpeg],
      'resume' => %w[application/pdf text/plain application/msword application/vnd.oasis.opendocument.text application/vnd.openxmlformats-officedocument.wordprocessingm]
    }
    mimes[type]
  end

  def activity
    algo_submissions = AlgoSubmission.where(user_id: id, is_submitted: true).group('Date(created_at)').count
    fe_submissions = FeSubmission.where(user_id: id, is_submitted: true).group('Date(created_at)').count

    algo_submissions.merge(fe_submissions) { |_k, a_value, b_value| a_value + b_value }
  end

  def unsubscribe_token
    payload = {
      user_id: id,
      user_name: username,
      initiated_at: Time.now
    }
    JWT.encode(payload, Rails.application.secrets.secret_key_base)
  end

  # when new user signs up on the website, send them a welcome email
  def send_registration_email
    return unless web_active == true

    template_id = EmailTemplate.find_by(name: 'registration_mail_lm')&.template_id
    EmailSenderWorker.perform_async(email, {
                                      'unsubscribe_token': unsubscribe_token,
                                      'username': username
                                    }, template_id)
  end

  # sending 1st step of the 3 steps
  def send_step_one_mail
    if discord_active == false && saved_change_to_attribute?(:is_fullstack_course_22_form_filled) && is_fullstack_course_22_form_filled
      template_id = EmailTemplate.find_by(name: 'step_one_mail_with_discord_not_connected_lm')&.template_id
      EmailSenderWorker.perform_async(email, {
                                        'unsubscribe_token': unsubscribe_token, 'user_accepted': true, username: username
                                      }, template_id)
    elsif discord_active == true && saved_change_to_attribute?(:is_fullstack_course_22_form_filled) && is_fullstack_course_22_form_filled
      ServerUser.where(user_id: id, active: true).each do |server_user|
        server = Server.find_by(id: server_user.server_id)
        RoleModifierWorker.perform_async('add_role', discord_id, 'Verified', server.guild_id)
        RoleModifierWorker.perform_async('add_role', discord_id, 'DN JUNE BATCH', server.guild_id)
      end
      template_id = EmailTemplate.find_by(name: 'step_one_mail_with_discord_connected_lm')&.template_id
      EmailSenderWorker.perform_async(email, {
                                        'unsubscribe_token': unsubscribe_token, 'user_accepted': true, 'username': username
                                      }, template_id)
    end
  end

  # sending 2st step of the 3 steps
  def send_step_two_mail_if_discord_active_false
    return unless web_active && is_fullstack_course_22_form_filled && saved_change_to_attribute?(:discord_active) && discord_active

    template_id = EmailTemplate.find_by(name: 'step_one_mail_with_discord_connected_lm')&.template_id
    EmailSenderWorker.perform_async(email, {
                                      'unsubscribe_token': unsubscribe_token,
                                      'username': username
                                    }, template_id)
  end

  def update_user_coins_for_signup
    return unless web_active && is_fullstack_course_22_form_filled && saved_change_to_attribute?(:discord_active) && discord_active

    referred_user = Referral.find_by(referred_user_id: id)
    return unless referred_user.present?

    refered_by = User.find_by(referral_code: referred_user.referral_code)
    refered_by.update(coins: refered_by.coins + 10) if refered_by.present?
  end

  def is_admin?
    user_type == 'admin'
  end

  def is_batchleader?
    Group.where(batch_leader_id: id).present?
  end

  def github_client
    decoded_access_token = $cryptor.decrypt_and_verify(github_token)[:access_token]
    Octokit::Client.new(access_token: decoded_access_token)
  end

  def create_github_commit(commited_files, repo, commit_message = 'Added All Files')
    ref = 'heads/main'
    client = github_client
    repo = "#{client.user.login}/#{repo}"

    # SHA of the latest commit on branch
    sha_latest_commit = client.ref(repo, ref).object.sha
    # Find and store the SHA for the tree object that the heads/master commit points to.
    sha_base_tree = client.commit(repo, sha_latest_commit).commit.tree.sha

    blobs = []
    # Create Blobs of all the files
    commited_files.each do |file_path, content|
      blob_sha = client.create_blob(repo, content, 'base64')
      blobs << { path: file_path, mode: '100644', type: 'blob', sha: blob_sha }
    end

    # Make a new tree over the base tree
    sha_new_tree = client.create_tree(repo, blobs, { base_tree: sha_base_tree }).sha
    # Create the commit over the new tree
    sha_new_commit = client.create_commit(repo, commit_message, sha_new_tree, sha_latest_commit).sha
    # Update the branch on github
    client.update_ref(repo, ref, sha_new_commit)

    true
  end

  def update_github_secret(repo, secret_name, secret_value)
    client = github_client

    # Get the public key of repository to encrypt secrets
    key_info = client.get("https://api.github.com/repos/#{client.user.login}/#{repo}/actions/secrets/public-key")
    repo_public_key = Base64.decode64(key_info[:key]) # Key comes in Base64 encoded
    repo_public_key_id = key_info[:key_id]

    # Making a new public key from repo public key to encrypt the secret
    public_key = RbNaCl::PublicKey.new(repo_public_key)
    box = RbNaCl::Boxes::Sealed.from_public_key(public_key)
    encrypted_secret = box.encrypt(secret_value)

    # Creating/Updating the github secret in the repo
    client.put("/repos/#{client.user.login}/#{repo}/actions/secrets/#{secret_name}", {
                 encrypted_value: Base64.strict_encode64(encrypted_secret),
                 key_id: repo_public_key_id
               })

    true
  end

  def self.get_by_cache(id)
    Rails.cache.fetch("user_#{id}", expires_in: 1.day) do
      User.find_by(id: id)
    end
  end

  def expire_cache
    Rails.cache.delete("user_#{id}")
  end

  def leaderboard_details(leaderboard_type)
    case leaderboard_type
    when 'frontend'
      main_lb = LeaderboardDevsnest::FEInitializer::LB
    when 'dsa'
      main_lb = LeaderboardDevsnest::DSAInitializer::LB
    when 'backend'
      main_lb = LeaderboardDevsnest::BEInitializer::LB
    end
    rank = main_lb&.rank_for(username)

    nil unless rank.present?
    { rank: rank, score: main_lb&.score_for(username) } # Can add other leaderboard details in future
  end

  def tha_details(college_id = nil)
    # Temporary solution for JTD Bootcamp
    course_associated_with_college = College.find_by_id(college_id)&.course_modules&.first&.courses&.first
    current_course = course_associated_with_college || Course.first # Adding Course.first for handling old groups
    course_curriculum_ids = current_course&.course_curriculums&.where(locked: false)&.pluck(:id) || []
    current_module = current_course.current_module
    case current_module
    when 'dsa'
      total_assignments_challenge_ids = AssignmentQuestion.where(course_curriculum_id: course_curriculum_ids, question_type: 'Challenge').pluck(:question_id).uniq
      solved_assignments_count = UserChallengeScore.where(user_id: id, challenge_id: total_assignments_challenge_ids).where('passed_test_cases = total_test_cases').count
    when 'frontend'
      total_assignments_challenge_ids = AssignmentQuestion.where(course_curriculum_id: course_curriculum_ids, question_type: 'FrontendChallenge').pluck(:question_id).uniq
      solved_assignments_count = FrontendChallengeScore.where(user_id: id, frontend_challenge_id: total_assignments_challenge_ids).where('passed_test_cases = total_test_cases').count
    when 'backend'
      total_assignments_challenge_ids = AssignmentQuestion.where(course_curriculum_id: course_curriculum_ids, question_type: 'BackendChallenge').pluck(:question_id).uniq
      solved_assignments_count = BackendChallengeScore.where(user_id: id, backend_challenge_id: total_assignments_challenge_ids).where('passed_test_cases = total_test_cases').count
    end

    {
      total_assignments_count: total_assignments_challenge_ids.count,
      solved_assignments_count: solved_assignments_count
    }
  end

  def bootcamp_progress_details
    BootcampProgress.includes(:course_module).where(user_id: id).map do |progress|
      progress.attributes.merge(course_module_type: progress.course_module.try(:module_type), course_module_name: progress.course_module.try(:name))
    end
  end

  def group_details
    group = GroupMember.find_by(user_id: id)&.group
    return {} unless group.present?

    {
      group_slug: group.slug,
      group_name: group.name
    }
  end

  def lb_data(lb_main, lb_copy)
    user = lb_main.score_and_rank_for(username)
    user_prev_rank = lb_copy.rank_for(username)
    user.merge(rank_change: user_prev_rank.zero? ? user_prev_rank : user_prev_rank - user[:rank])
  end

  def get_dashboard_by_cache(college_id = nil)
    Rails.cache.fetch("user_dashboard_#{id}", expires_in: 1.day) do
      {
        name: name,
        dsa_solved: Challenge.count_solved(id),
        dsa_solved_by_difficulty: Challenge.split_by_difficulty,
        fe_solved: FrontendChallenge.count_solved(id),
        fe_solved_by_topic: FrontendChallenge.split_by_topic,
        tha_details: tha_details(college_id), # Bootcamp Progress
        leaderboard_details: leaderboard_details('dsa'),
        fe_leaderboard_details: leaderboard_details('frontend')
      }
    end
  end

  def expire_dashboard_cache
    User.expire_dashboard_cache(id)
  end

  def self.expire_dashboard_cache(id)
    Rails.cache.delete("user_dashboard_#{id}")
  end

  def create_college_student
    CollegeStudent.create!(email: email, name: name, user_id: id) if is_college_student
  end

  def add_user_to_listmonk
    return if web_active == false

    response = $listmonk.add_subscriber(self, [])
    if response.success?
      parsed_out_id = JSON.parse(response.body)['data']['id']
      update_column(:listmonk_subscriber_id, parsed_out_id)
    else
      p JSON.parse(response.body)
    end
  end
end
