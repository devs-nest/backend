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
require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }
  let(:user2) { create(:user) }

  context 'basic tests' do
    it 'test new user' do
      expect(user.email).to be_present
      expect(user.name).to be_present
      expect(user.username).to be_present
      expect(user2.discord_id).to be_present
      expect(user2.encrypted_password).to be_present
    end
  end

  let(:valid_user) do
    { 'id' => '377019241473245195',
      'name' => 'KayDee',
      'username' => 'KayDee',
      'avatar' => '3bb80e2861f477c9e128635aad04914b',
      'discriminator' => '3187',
      'public_flags' => 128,
      'flags' => 128,
      'locale' => 'en-US',
      'mfa_enabled' => false,
      'email' => 'kshitijdhama513@gmail.com',
      'verified' => true }
  end

  context 'create user test' do
    before do
      @new_user = User.create_google_user(valid_user)
    end

    it 'creates a discord user' do
      expect(@new_user).to be_present
    end

    it 'checks if user is in database' do
      expect(User.find_by(name: 'KayDee')).to be_present
    end
  end

  context 'check to_csv method' do
    it 'checks for empty csv' do
      expect(described_class.to_csv).to eq "id,discord_username,discord_id,name,grad_year,school,work_exp,known_from,dsa_skill,webd_skill\n"
    end

    # it 'checks for some fields' do
    #   create(:user, discord_username: "testuser", discord_id: "24422", grad_year: 2, work_exp: "2",known_from: "Friend", dsa_skill: 5, webd_skill: 3, is_discord_form_filled: true)
    #   create(:user, discord_username: "testuser1", discord_id: "223233", grad_year: 4, work_exp: "4 year",known_from: "Linkdin", dsa_skill: 2, webd_skill: 4, is_discord_form_filled: false)
    #   expect(described_class.to_csv).to eq "id,discord_username,discord_id,name,grad_year,school,work_exp,known_from,dsa_skill,webd_skill\n204,testuser,24422,8 user,2,,2,Friend,5,3\n205,testuser1,223233,9 user,4,,4 year,Linkdin,2,4\n"

    # end
  end
end
