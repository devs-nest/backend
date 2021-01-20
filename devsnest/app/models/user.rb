# frozen_string_literal: true

class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :omniauthable,
         :recoverable, :rememberable, :validatable
  devise :omniauthable, omniauth_providers: %i[discord]

  def self.find_for_discord(discord_hash)
    email = discord_hash.info['email'] || discord_hash.extra.raw_info.email
    username = discord_hash.extra.raw_info.username
    user = User.where(discord_id: discord_hash.uid).first

    if user.present?
      user.update(email: email, provider: discord_hash.provider, web_active: true) if user.email != email
      return user
    end

    User.create(
      name: discord_hash.info['name'],
      username: username,
      email: email,
      discord_id: discord_hash.uid,
      provider: discord_hash.provider,
      password: Devise.friendly_token[0, 20],
      web_active: true
    )
  end
end
