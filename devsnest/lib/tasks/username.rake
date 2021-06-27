# frozen_string_literal: true

namespace :upgrade do
  task data: :environment do
    User.all.each do |u|
      next unless check_username(u.username)

      suffix = ''
      count = 0

      if u.web_active == false && u.discord_active == true
        suffix = (count += 1).to_s while User.find_by(username: 'testuser' + suffix)
        u.username = 'testuser' + suffix
      else
        suffix = (count += 1).to_s while User.find_by(username: u.email.split('@')[0] + suffix)
        u.username = u.email.split('@')[0] + suffix
      end
      u.save
    end
  end
  def check_username(username)
    username.match(/^(?!.*\.\.)(?!.*\.$)[^\W][\w.]{4,29}$/).nil?
  end
end
