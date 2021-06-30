# frozen_string_literal: true

# user onboarding
class Onboard < ApplicationRecord
  def self.to_csv
    attributes = %w[user_id discord_username discord_id name college college_year school work_exp known_from dsa_skill webd_skill]

    CSV.generate(headers: true) do |csv|
      csv << attributes

      where('created_at >= ?', 2.weeks.ago).each do |user|
        csv << attributes.map { |attr| user.send(attr) }
      end
    end
  end
end
