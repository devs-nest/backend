# frozen_string_literal: true

# User Model
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :jwt_authenticatable,
         jwt_revocation_strategy: JwtBlacklist
  after_create :create_bot_token
  enum user_type: %i[user admin problem_setter]
  after_create :create_username
  validates_uniqueness_of :username
  validates :referral_code, uniqueness: true
  validates :dob, inclusion: { in: (Date.today - 60.years..Date.today) }, allow_nil: true
  belongs_to :college, optional: true
  has_many :internal_feedbacks
  has_many :frontend_projects, dependent: :delete_all
  has_many :unsubscribes, dependent: :delete_all
  has_many :algo_submissions
  has_many :challenges
  has_many :minibootcamp_submissions
  has_many :certifications, dependent: :delete_all
  has_many :manual_login_changelog
  before_save :markdown_encode, if: :will_save_change_to_markdown?
  after_create :assign_bot_to_user
  after_create :send_registration_email
  after_update :send_step_one_mail
  after_update :send_step_two_mail_if_discord_active_false
  after_update :update_user_coins_for_signup
  after_create :create_referral_code

  def create_username
    username = ''
    count = 0
    temp = email.split('@')[0].gsub(/[^0-9A-Za-z]/, '')
    username = (count += 1).to_s while User.find_by(username: temp + username)
    update_attribute(:username, temp + username)
  end

  def assign_bot_to_user
    update_attribute(:bot_id, rand(1..20))
  end

  def create_referral_code
    update(referral_code: SecureRandom.hex(2)) if web_active == true
  end

  def self.fetch_discord_id(code)
    token = fetch_discord_access_token(code)
    return if token.nil?

    user_details = fetch_discord_user_details(token)
    return if user_details.nil?

    user_details['id']
  end

  def self.fetch_google_user(code, googleId, referral_code = '')
    user_details = fetch_google_user_details(code)
    return if user_details.nil?

    user = create_google_user(user_details, googleId, referral_code)
    Referral.create(referral_code: referral_code, referred_user_id: User.last.id) if referral_code.present?
    user
  end

  def self.fetch_google_user_details(code)
    url = URI("https://oauth2.googleapis.com/tokeninfo?id_token=#{code}")
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    request = Net::HTTP::Post.new(url)
    response = https.request(request)
    JSON(response.read_body)
  end

  def self.create_google_user(user_details, googleId, _referral_code = '')
    email = user_details['email']
    name = user_details['name']
    user = User.where(email: email).first
    avatar = nil
    avatar = user_details['picture'] if user_details['picture'].present?
    if user.present?
      user.update(web_active: true, google_id: googleId)
      return user
    end

    User.create(
      name: name,
      username: name,
      email: email,
      password: Devise.friendly_token[0, 20],
      web_active: true,
      image_url: avatar,
      google_id: googleId,
      is_verified: true
    )
  end

  def merge_discord_user(discord_id, temp_user)
    update(discord_id: discord_id, discord_active: true)
    if temp_user.present?
      group_member = GroupMember.find_by(user_id: temp_user.id)
      if group_member.present?
        group_member.update(user_id: id)
        group = Group.find_by(id: group_member.group_id)
        if group.owner_id == temp_user.id
          group.update(owner_id: id)
        elsif group.co_owner_id == temp_user.id
          group.update(co_owner_id: id)
        end
      end
      Group.where(batch_leader_id: temp_user.id).update_all(batch_leader_id: id)
      Submission.merge_submission(temp_user, self)
      update(score: Submission.where(user_id: id, status: 'done').count)
      temp_user.destroy
    end
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
  def self.initialize_leaderboard(leaderboard)
    find_each do |user|
      leaderboard.rank_member(user.username, user.score || 0)
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
    algo_submissions.where(is_submitted: true).group('Date(created_at)').count
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
    if web_active == true
      template_id = EmailTemplate.find_by(name: 'registration_mail')&.template_id
      EmailSenderWorker.perform_async(email, {
                                        'unsubscribe_token': unsubscribe_token
                                      }, template_id)
    end
  end

  # sending 1st step of the 3 steps
  def send_step_one_mail
    if discord_active == false && saved_change_to_attribute?(:is_fullstack_course_22_form_filled) && is_fullstack_course_22_form_filled
      template_id = EmailTemplate.find_by(name: 'step_one_mail_with_discord_not_connected')&.template_id
      EmailSenderWorker.perform_async(email, {
                                        'unsubscribe_token': unsubscribe_token, 'user_accepted': true
                                      }, template_id)
    elsif discord_active == true && saved_change_to_attribute?(:is_fullstack_course_22_form_filled) && is_fullstack_course_22_form_filled
      template_id = EmailTemplate.find_by(name: 'step_one_mail_with_discord_connected')&.template_id
      EmailSenderWorker.perform_async(email, {
                                        'unsubscribe_token': unsubscribe_token, 'user_accepted': true
                                      }, template_id)
    end
  end

  # sending 2st step of the 3 steps
  def send_step_two_mail_if_discord_active_false
    if web_active && is_fullstack_course_22_form_filled && saved_change_to_attribute?(:discord_active) && discord_active
      template_id = EmailTemplate.find_by(name: 'step_two_mail')&.template_id
      EmailSenderWorker.perform_async(email, {
                                        'unsubscribe_token': unsubscribe_token
                                      }, template_id)
    end
  end

  def update_user_coins_for_signup
    # byebug
    if web_active && is_fullstack_course_22_form_filled && saved_change_to_attribute?(:discord_active) && discord_active
      referred_user = Referral.find_by(referred_user_id: id)
      if referred_user.present?
        refered_by = User.find_by(referral_code: referred_user.referral_code)
        refered_by.update(coins: refered_by.coins + 10)
      end
    end
  end

  def is_admin?
    user_type == 'admin'
  end
end
