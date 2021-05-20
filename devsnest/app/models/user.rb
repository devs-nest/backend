# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :jwt_authenticatable,
         jwt_revocation_strategy: JwtBlacklist
  has_one :college


  def self.fetch_discord_user(code)
    token = fetch_access_token(code)
    return if token.nil?

    user_details = fetch_user_details(token)
    return if user_details.nil?

    user = create_user(user_details)
    return user
  end

  def self.create_user(user_details)
    email = user_details['email']
    username = user_details['username']
    user = User.where(discord_id: user_details['id']).first
    avatar = nil
    if user_details['avatar'].present?
      avatar = "https://cdn.discordapp.com/avatars/#{user_details['id']}/#{user_details['avatar']}.png"
    end
    if user.present?
      user.update(email: email, web_active: true, image_url: avatar) if user.email != email
      return user
    end

    User.create(
      name: user_details['username'],
      username: username,
      email: email,
      discord_id: user_details['id'],
      password: Devise.friendly_token[0, 20],
      web_active: true,
      image_url: avatar
    )
  end

  def self.fetch_access_token(code)
    url = URI("https://discordapp.com/api/oauth2/token")
    token = "Basic "+ Base64.strict_encode64("#{ENV['DISCORD_CLIENT_ID']}:#{ENV['DISCORD_CLIENT_SECRET']}")

    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true
    request = Net::HTTP::Post.new(url)

    request["Authorization"] = token
    request["Content-Type"] = "application/x-www-form-urlencoded"
    request.body = "code=#{code}&grant_type=authorization_code&redirect_uri=#{ENV['DISCORD_REDIRECT_URI']}"

    response = https.request(request)
    response.code == "200" ? JSON(response.read_body)["access_token"] : nil
  end

  def self.fetch_user_details(token)
    url = "http://discordapp.com/api/users/@me"
    headers = {
      'Content-Type' => 'application/json',
      Authorization: "Bearer #{token}"
    }

    response = HTTParty.post(url, :body => {}, :headers => headers)
    response.code == 200 ? JSON(response.read_body) : nil
  end
end


