require 'rails_helper'

RSpec.describe Api::V1::GroupsController, type: :request do
  context 'basic show req' do
    let(:user) { create(:user, user_type: 1) } # admin
    let!(:user2) { create(:user, user_type: 0) }
    let(:controller) { Api::V1::AdminController }

    it 'check deslug' do
      sign_in(user)
      group1 = create(:group, name: 'delta')
      group_member1 = create(:group_member, user_id: user.id, group_id: group1.id)
      get '/api/v1/groups/delta'
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body, symbolize_names: true)[:data][:id]).to eq(group1.id.to_s)
    end

    it 'checks forbidden' do
      sign_in(user2)
      group2 = create(:group, name: 'gamma')
      get '/api/v1/groups/gamma'
      expect(response.status).to eq(403)
    end

    it 'deletes group' do
      sign_in(user)
      group3 = create(:group, name: 'rho')
      delete '/api/v1/groups/delete_group', headers: { 'Token': ENV['DISCORD_TOKEN'], 'User-Type': 'Bot' }, params: { "data": { "attributes": { "group_name": 'rho' } } }
      expect(response.status).to eq(204)
      sign_in(user)
      get '/api/v1/groups/rho'
      expect(response.status).to eq(404)
    end

    it 'renames group' do
      sign_in(user)
      group4 = create(:group, name: 'omega')
      new_group_name = 'zeta'
      put '/api/v1/groups/update_group_name', headers: { 'Token': ENV['DISCORD_TOKEN'], 'User-Type': 'Bot' },
                                              params: { "data": { "attributes": { "old_group_name": group4.name, "new_group_name": new_group_name } } }
      expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:name]).to eq(new_group_name)
    end

    it 'shows group data of a valid member' do
      sign_in(user2)
      co_owner = create(:user, name: 'co-owner')
      group1 = create(:group, name: 'omega', owner_id: user2.id, co_owner_id: co_owner.id)
      group_member1 = create(:group_member, user_id: user2.id, group_id: group1.id)
      get '/api/v1/groups', headers: HEADERS
      expect(response.status).to eq(200)
    end
  end
end
