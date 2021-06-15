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
      @new_user = User.create_google_user(valid_user,9000)
    end

    it 'creates a discord user' do
      expect(@new_user).to be_present
    end

    it 'checks if user is in database' do
      expect(User.find_by(google_id: 9000)).to be_present
    end
  end
end
