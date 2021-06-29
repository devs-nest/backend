# frozen_string_literal: true

FactoryBot.define do
  factory :content do
    sequence(:name) { |n| "Test Q #{n}" }
    sequence(:link) { |n| "Test link #{n}" }
    sequence(:data_type) { [0, 1, 2, 3, 4].sample }
    sequence(:difficulty) { [0, 1, 2].sample }
  end
  factory :weekly_todo do
    sequence(:group_id) { |n| n }
    sequence(:creation_week) { Date.today.at_beginning_of_week }
  end

  factory :group do
    sequence(:name) { |n| "#{n} group" }
    sequence(:batch_leader_id) { |n| n }
    sequence(:owner_id) { |n| n }
    sequence(:co_owner_id) { |n| n }
  end
  factory :group_member do
    sequence(:user_id) { |n| n }
    sequence(:group_id) { |n| n }
    sequence(:owner) { [true, false].sample }
  end
  factory :user do
    sequence(:name) { |n| "#{n} user" }
    sequence(:email) { |n| "#{n}@test.com" }
    sequence(:username) { |n| n.to_s }
    sequence(:dob) { Time.zone.now - rand(3000).days }
    sequence(:discord_id) { |n| n }
    sequence(:password) { |n| "mypass#{n}" }
    sequence(:web_active) { |_n| true }
    sequence(:image_url) { |n| "test.com/#{n}.png" }
  end

  factory :batch_leader_sheet do
    sequence(:user_id) { |n| n }
    sequence(:group_id) { |n| n }
  end

  factory :group do
    sequence(:name) { |n| "#{n} group" }
    sequence(:batch_leader_id) { |n| n }
    sequence(:owner_id) { |n| n }
  end
end
