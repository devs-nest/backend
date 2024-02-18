# frozen_string_literal: true

namespace :subscribers do
  desc 'listmonk related rakes'
  task add_subscribers: :environment do
    desc 'add subscribers'

    User.where(web_active: true).all.in_batches(of: 100) do |batch|
      batch.each do |user|
        current_subscriber = $listmonk.get_subscribers_details(email: user.email)

        if current_subscriber.present?
          p user.update_column(:listmonk_subscriber_id, current_subscriber.first['id'])
        else
          response = $listmonk.add_subscriber(user, [])
          if response.success?
            parsed_out_id = JSON.parse(response.body)['data']['id']
            user.update_column(:listmonk_subscriber_id, parsed_out_id)
          else
            p JSON.parse(response.body)
          end
        end
      end
    end
  end

  def check_username(username)
    username.match(/^(?!.*\.\.)(?!.*\.$)[^\W][\w.]{4,29}$/).nil?
  end
end
