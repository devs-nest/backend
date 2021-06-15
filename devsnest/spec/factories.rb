# frozen_string_literal: true

FactoryBot.define do
  factory :content do
    sequence(:name) { |n| "Test Q #{n}" }
    sequence(:link) { |n| "Test link #{n}" }
    sequence(:data_type) { [0,1,2,3,4].sample }
    sequence(:difficulty) { [0,1,2].sample }
    
  end

  factory :user do
    sequence(:name) { |n| "#{n} user" }
    sequence(:email) { |n| "#{n}@test.com" }
    sequence(:username) { |n| "#{n}" }
    sequence(:discord_id) { |n| n }
    sequence(:password) { |n| "mypass#{n}" }
    sequence(:web_active) { |n| true }
    sequence(:image_url) { |n| "test.com/#{n}.png" }
  end
end
