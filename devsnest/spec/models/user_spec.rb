# frozen_string_literal: true

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
      @new_user = User.create_google_user(valid_user, 9000)
    end

    it 'creates a discord user' do
      expect(@new_user).to be_present
    end

    it 'checks if user is in database' do
      expect(User.find_by(google_id: 9000)).to be_present
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
