# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GroupMember, type: :request do
  context 'GroupMember - request specs' do
    context 'Get GroupMember' do
      let(:group) { create(:group) }
      let(:user) { create(:user) }
      let(:group_member) { create(:group_member) }

      it 'should return unauthorized if user is not logged in' do
        get '/api/v1/group-members'
        expect(response).to have_http_status(401)
      end

      let(:params) { { 'group_id': group.id } }

      it 'should return forbidden if user if not part of group' do
        sign_in(user)
        get '/api/v1/group-members', params: params
        expect(response).to have_http_status(403)
      end

      it 'should not return forbidden if user is part of group' do
        sign_in(user)
        group.group_members.create(user_id: user.id, group_id: group.id)
        get '/api/v1/group-members', params: params
        expect(response).to have_http_status(200)
      end

      it 'should not return forbidden if user is admin' do
        sign_in(user)
        user.update(user_type: 1)
        get '/api/v1/group-members', params: params
        expect(response).to have_http_status(200)
      end

      it 'should not return forbidden if user is batch_leader of group' do
        sign_in(user)
        group.update(batch_leader_id: user.id)
        get '/api/v1/group-members', params: params
        expect(response).to have_http_status(200)
      end
    end

    context 'Create Group Member' do
      let(:group) { create(:group) }
      let(:newgroup) { create(:group) }
      let(:user) { create(:user) }
      let(:group_member) { create(:group_member) }
      let(:discord_id) { user.discord_id }

      before :each do
        sign_in(user)
      end

      let(:bot_headers) do
        {
          'ACCEPT' => 'application/vnd.api+json',
          'CONTENT-TYPE' => 'application/vnd.api+json',
          'Token' => ENV['DISCORD_TOKEN'],
          'User-Type' => 'Bot'
        }
      end

      let(:params) do
        {

          "data": {
            "attributes": {
              "user_id": user.id,
              "group_id": group.id,
              "is_vice_team_leader": true,
              "is_team_leader": false,
              "updated_group_name": newgroup.name,
              "discord_id": discord_id
            },
            "type": 'group_members'
          }
        }
      end

      it 'should return error if user discord id is invalid' do
        params[:data][:attributes][:discord_id] = 0
        post '/api/v1/group-members/update_user_group', headers: bot_headers, params: params.to_json
        expect(response).to have_http_status(400)
        expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:error]).to eq('User not found')
      end

      it 'should create the group_member if user is already part of a group' do
        group.group_members.create(user_id: user.id, group_id: group.id)
        post '/api/v1/group-members/update_user_group', headers: bot_headers, params: params.to_json
        expect(response).to have_http_status(200)
      end

      it 'should create the group_member if user is not part of any group' do
        post '/api/v1/group-members/update_user_group', headers: bot_headers, params: params.to_json
        expect(response).to have_http_status(200)
      end

      it 'should destroy the previous group_member if no new group name is present' do
        params[:data][:attributes].delete :updated_group_name
        group.group_members.create(user_id: user.id, group_id: group.id)
        post '/api/v1/group-members/update_user_group', headers: bot_headers, params: params.to_json
        expect(response).to have_http_status(200)
        expect(group.group_members.where(user_id: user.id)).to eq([])
      end
    end
  end
end
