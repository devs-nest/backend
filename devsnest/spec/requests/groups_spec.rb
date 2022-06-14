# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::GroupsController, type: :request do
  context 'Groups Request Spec' do
    let!(:server1) { create(:server, id: 1, name: 'Devsnest', guild_id: '123456789') }
    let!(:server2) { create(:server, name: 'Devsnest1', guild_id: '123456789') }
    context 'Create Groups' do
      let!(:user) { create(:user, user_type: 1) } # admin
      let!(:user2) { create(:user, user_type: 0, discord_active: true) }
      let!(:new_user) { create(:user, user_type: 0, discord_active: true, accepted_in_course: true) }
      let(:controller) { Api::V1::AdminController }
      let!(:params) do
        {
          "data": {
            "attributes": {
              "name": 'grp rspec',
              "group_type": 'private',
              "language": 'hindi',
              "classification": 'students'
            },
            "type": 'groups'
          }

        }
      end

      it 'creates a group' do
        sign_in(new_user)
        post '/api/v1/groups', headers: HEADERS, params: params.to_json
        expect(response.status).to eq(201)
        expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:name]).to eq('grp rspec')
      end

      it 'older user tries to creates a group' do
        sign_in(user2)
        post '/api/v1/groups', headers: HEADERS, params: params.to_json
        expect(response.status).to eq(401)
      end

      # it 'checks forbidden' do
      #   sign_in(user2)
      #   create(:group, name: 'gamma')
      #   get '/api/v1/groups/gamma'
      #   expect(response.status).to eq(403)
      # end
    end

    context 'Create Groups and leave xD' do
      let!(:user) { create(:user, user_type: 1) } # admin
      let!(:user2) { create(:user, user_type: 0, discord_active: true, accepted_in_course: true) }
      let!(:new_user) { create(:user, user_type: 0, discord_active: true, accepted_in_course: true) }
      let(:controller) { Api::V1::AdminController }
      let!(:params) do
        {
          "data": {
            "attributes": {
              "name": 'grp rspec',
              "group_type": 'private',
              "language": 'hindi',
              "classification": 'students'
            },
            "type": 'groups'
          }

        }
      end

      it 'creates a group and leave' do
        sign_in(new_user)
        post '/api/v1/groups', headers: HEADERS, params: params.to_json
        expect(response.status).to eq(201)
        expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:name]).to eq('grp rspec')

        sign_in(new_user)
        group = Group.find_by(slug: 'grp-rspec')
        post "/api/v1/groups/#{group.id}/leave", params: { "data": { "attributes": {}, "type": 'group' } }.to_json, headers: HEADERS
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:message]).to eq('Group left')
        expect(Group.find_by(slug: 'grp-rspec')).to be_nil
      end

      it 'creates a group and leave reassign leader' do
        sign_in(new_user)
        post '/api/v1/groups', headers: HEADERS, params: params.to_json
        expect(response.status).to eq(201)
        expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:name]).to eq('grp rspec')

        group = Group.find_by(slug: 'grp-rspec')
        sign_in(user2)
        post '/api/v1/groups/join', params: { "data": { "attributes": { "group_id": group.id }, "type": 'group' } }.to_json, headers: HEADERS
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:message]).to eq('Group joined')

        sign_in(new_user)
        post "/api/v1/groups/#{group.id}/leave", params: { "data": { "attributes": {}, "type": 'group' } }.to_json, headers: HEADERS
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:message]).to eq('Group left')
        expect(Group.find_by(slug: 'grp-rspec')).to be_present
      end
    end

    context 'Get Groups' do
      let!(:user) { create(:user, user_type: 1) } # admin
      let!(:user2) { create(:user, user_type: 0) }
      let!(:new_user) { create(:user, user_type: 0, discord_active: true, accepted_in_course: true) }
      let(:controller) { Api::V1::AdminController }
      let(:group) { create(:group, owner_id: user.id, server_id: server1.id) }

      it 'check deslug' do
        sign_in(user)
        group1 = create(:group, name: 'delta', server_id: server1.id)
        create(:group_member, user_id: user.id, group_id: group1.id)
        get '/api/v1/groups/delta'
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body, symbolize_names: true)[:data][:id]).to eq(group1.id.to_s)
      end

      it 'list v1 groups' do
        sign_in(new_user)
        group1 = create(:group, name: 'delta', server_id: server1.id)
        create(:group_member, user_id: user.id, group_id: group1.id)
        get '/api/v1/groups?v1=true'
        expect(response.status).to eq(200)
      end

      # it 'checks forbidden' do
      #   sign_in(user2)
      #   create(:group, name: 'gamma')
      #   get '/api/v1/groups/gamma'
      #   expect(response.status).to eq(403)
      # end

      it 'joins the group' do
        sign_in(new_user)
        post '/api/v1/groups/join', params: { "data": { "attributes": { "group_id": group.id }, "type": 'group' } }.to_json, headers: HEADERS
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:message]).to eq('Group joined')

        sign_in(new_user)
        post '/api/v1/groups/join', params: { "data": { "attributes": { "group_id": group.id }, "type": 'group' } }.to_json, headers: HEADERS
        expect(response.status).to eq(400)
        expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:error][:message]).to eq('User already in a group')

        group = Group.find(GroupMember.find_by(user_id: new_user.id).group_id)
        sign_in(new_user)
        post "/api/v1/groups/#{group.id}/leave", params: { "data": { "attributes": { "group_id": group.id }, "type": 'group' } }.to_json, headers: HEADERS
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:message]).to eq('Group left')

        sign_in(new_user)
        post "/api/v1/groups/#{group.id}/leave", params: { "data": { "attributes": { "group_id": group.id }, "type": 'group' } }.to_json, headers: HEADERS
        expect(response.status).to eq(400)
        expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:error][:message]).to eq('User not in this group')
      end

      it 'promotes to vtl' do
        sign_in(new_user)
        post '/api/v1/groups/join', params: { "data": { "attributes": { "group_id": group.id }, "type": 'group' } }.to_json, headers: HEADERS
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:message]).to eq('Group joined')

        sign_in(user)
        post '/api/v1/groups/promote', params: { "data": { "attributes": { "user_id": new_user.id, "group_id": group.id, "promotion_type": 'co_owner' }, "type": 'group' } }.to_json, headers: HEADERS
        expect(response.status).to eq(200)
        expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:message]).to eq('User has been promoted')
      end

      it 'deletes group' do
        sign_in(user)
        create(:group, name: 'delta', server_id: server1.id)
        delete '/api/v1/groups/delete_group', headers: { 'Token': ENV['DISCORD_TOKEN'], 'User-Type': 'Bot' }, params: { "data": { "attributes": { "group_name": 'delta' } } }
        expect(response.status).to eq(204)
        sign_in(user)
        get '/api/v1/groups/delta'
        expect(response.status).to eq(404)
      end

      it 'shows group data of a valid member' do
        sign_in(user2)
        co_owner = create(:user, name: 'co-owner')
        group1 = create(:group, name: 'omega', owner_id: user2.id, co_owner_id: co_owner.id, server_id: server1.id)
        create(:group_member, user_id: user2.id, group_id: group1.id)
        get '/api/v1/groups', headers: HEADERS
        expect(response.status).to eq(200)
      end
    end

    context 'Update Groups' do
      let(:user) { create(:user, user_type: 1) }
      let(:group) { create(:group, name: 'Example', server_id: server1.id) }

      before :each do
        sign_in(user)
      end

      let(:params) do
        {

          "data": {
            "attributes": {
              "discord_id": user.discord_id,
              "group_name": group.name
            },
            "type": 'groups'
          }
        }
      end

      let(:headers) do
        { 'Token': ENV['DISCORD_TOKEN'], 'User-Type': 'Bot' }
      end

      it 'renames group' do
        group4 = create(:group, name: 'omega', server_id: server1.id)
        new_group_name = 'zeta'
        put '/api/v1/groups/update_group_name', headers: headers,
                                                params: { "data": { "attributes": { "old_group_name": group4.name, "new_group_name": new_group_name } } }
        expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:name]).to eq(new_group_name)
      end

      it 'should return error if group is nil while updating batch leader' do
        params[:data][:attributes][:group_name] = 'random name'
        put '/api/v1/groups/update_batch_leader', headers: headers, params: params
        expect(response.status).to eq(400)
        expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:error]).to eq('Group not found')
      end

      it 'should change the batch_leader while updating batch leader' do
        put '/api/v1/groups/update_batch_leader', headers: headers, params: params
        expect(response.status).to eq(204)
      end
    end
  end
end
