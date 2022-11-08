# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Listmonk', type: :model do
  let(:user) { create(:user, name: 'Kshitij Dhama', email: 'kshitijdhama513@gmail.com', listmonk_subscriber_id: 43) }
  let(:user2) { create(:user) }

  context 'list control' do
    it 'adds subscriber to list' do
      ep, response = $listmonk.get_list_debug
      expect(ep).to eq('http://listmonk.devsnest.in/api/lists')
      expect(response.code).to eq(200)
    end

    it 'adds subscriber to list' do
      user.update(web_active: true, discord_active: true)
      $listmonk.list_control([], user)

      response = $listmonk.get_subscriber(user.listmonk_subscriber_id)
      expect(response['data']['lists'].select { |l| l['name'] == 'test_active_members' }).to be_present
    end

    it 'removes user from list' do
      user.update(web_active: true, discord_active: false)
      $listmonk.list_control([], user)

      response = $listmonk.get_subscriber(user.listmonk_subscriber_id)
      expect(response['data']['lists'].select { |l| l['name'] == 'test_active_members' }).to be_blank
    end
  end
end
