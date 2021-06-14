# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :jwt_authenticatable,
         jwt_revocation_strategy: JwtBlacklist
  after_create :create_bot_token
  enum user_type: %i[user admin]

  def self.fetch_discord_id(code)
    token = fetch_discord_access_token(code)
    return if token.nil?

    user_details = fetch_discord_user_details(token)
    return if user_details.nil?

    user_details['id']
  end

  def self.fetch_google_user(code, googleId)
    user_details = fetch_google_user_details(code)
    return if user_details.nil?

    create_google_user(user_details, googleId)
  end

  def self.fetch_google_user_details(code)
    url = URI('https://oauth2.googleapis.com/tokeninfo?id_token=' + code)
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    request = Net::HTTP::Post.new(url)
    response = https.request(request)
    JSON(response.read_body)
  end

  def self.create_google_user(user_details, googleId)
    email = user_details['email']
    name = user_details['name']
    user = User.where(email: email).first
    avatar = nil
    avatar = user_details['picture'] if user_details['picture'].present?
    if user.present?
      user.update(web_active: true, image_url: avatar, google_id: googleId)
      return user
    end

    User.create(
      name: name,
      username: name,
      email: email,
      password: Devise.friendly_token[0, 20],
      web_active: true,
      image_url: avatar,
      google_id: googleId
    )
  end

  def merge_discord_user(discord_id, temp_user)
    self.update(discord_id: discord_id, discord_active: true)
    if temp_user.present?
      group_member = GroupMember.find_by(user_id: temp_user.id)
      group_member.update(user_id: self.id) if group_member.present?
      Submission.merge_submission(temp_user, self)
      temp_user.destroy
    end
  end

  def self.fetch_discord_access_token(code)
    url = URI('https://discordapp.com/api/oauth2/token')
    token = 'Basic ' + Base64.strict_encode64("#{ENV['DISCORD_CLIENT_ID']}:#{ENV['DISCORD_CLIENT_SECRET']}")

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
    if self.user_type == 'user'
      Group.where(batch_leader_id: self.id).pluck(:id) + GroupMember.where(user_id: self.id).pluck(:group_id)
    elsif self.user_type == 'admin'
      Group.all.ids
    end
  end

  def create_bot_token
    update(bot_token: Digest::SHA1.hexdigest([Time.now, rand].join))
  end
end
