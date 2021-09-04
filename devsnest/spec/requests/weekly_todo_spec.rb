# frozen_string_literal: true

require 'rails_helper'

RSpec.describe WeeklyTodo, type: :request do
  context 'Weekly Todo - request specs' do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }
    let(:owner) { create(:user) }
    let(:co_owner) { create(:user) }
    let(:batch_leader) { create(:user) }
    let!(:admin) { create(:user, user_type: 1) }
    let(:group1) { create(:group, owner_id: owner.id, co_owner_id: co_owner.id, batch_leader_id: batch_leader.id) }
    let!(:group_member) { create(:group_member, user_id: user1.id, group_id: group1.id) }
    let!(:wt1) { create(:weekly_todo, group_id: group1.id) }
    let(:parameters_index) do
      {
        "group_id": group1.id
      }
    end

    let(:parameters_create) do
      {
        "data": {
          "type": 'weekly_todos',
          "attributes": {
            "group_id": group1.id,
            "sheet_filled": false,
            "batch_leader_rating": 0,
            "extra_activity": 'null',
            "group_activity_rating": 0,
            "moral_status": 0,
            "obstacles": 'null',
            "comments": 'null',
            "todo_list": [
              {
                "title": 'Hey',
                "status": true
              }
            ]

          }
        }
      }
    end

    let(:parameters_update) do
      {

        "data": {
          "id": wt1.id,
          "type": 'weekly_todos',

          "attributes": {

            "sheet_filled": true,
            "batch_leader_rating": 0,
            "extra_activity": '',
            "group_activity_rating": 0,
            "moral_status": 0,
            "obstacles": '',
            "comments": '',
            "todo_list": [
              { "title": 'Added a new one',
                "status": true }
            ]
          }
        }

      }
    end

    context 'Authorize Index' do
      it 'returns error when user does not belongs to the group and nither an admin nor the group batchleader' do
        sign_in(user2)
        get '/api/v1/weekly-todo', params: parameters_index, headers: HEADERS
        expect(response).to have_http_status(403)
      end

      it 'returns no error when user does belongs to the group' do
        sign_in(user1)
        get '/api/v1/weekly-todo', params: parameters_index, headers: HEADERS
        expect(response).to have_http_status(200)
      end

      it 'returns no error when user does not belongs to the group but an admin ' do
        sign_in(admin)
        get '/api/v1/weekly-todo', params: parameters_index, headers: HEADERS
        expect(response).to have_http_status(200)
      end

      it 'returns no error when user does not belongs to the group but group batchleader ' do
        sign_in(batch_leader)
        get '/api/v1/weekly-todo', params: parameters_index, headers: HEADERS
        expect(response).to have_http_status(200)
      end
    end

    context ' Authoize Create (errors)' do
      before(:each) do
        WeeklyTodo.last.destroy
      end

      it 'should return an error when passing creation_week' do
        sign_in(user2)
        group1.update(batch_leader_id: user2.id)
        parameters_create[:data][:attributes][:creation_week] = Date.current

        post '/api/v1/weekly-todo', params: parameters_create.to_json, headers: HEADERS
        expect(response).to have_http_status(400)
        expect(JSON.parse(response.body, symbolize_names: true)[:errors][0][:detail]).to eq('creation_week is not allowed.')
      end

      it 'returns an error when user does not belongs to the group and nither an admin nor the group batchleader' do
        sign_in(user2)
        post '/api/v1/weekly-todo', params: parameters_create.to_json, headers: HEADERS
        expect(response).to have_http_status(400)
      end
    end

    context ' Authoize Create (should not return an error)' do
      before(:each) do
        WeeklyTodo.last.destroy
      end
      it 'should not return an error when user does belongs to the group' do
        sign_in(user1)
        post '/api/v1/weekly-todo', params: parameters_create.to_json, headers: HEADERS
        expect(response).to have_http_status(201)
      end

      it 'should not return an error when user does not belongs to the group but an admin' do
        sign_in(admin)
        post '/api/v1/weekly-todo', params: parameters_create.to_json, headers: HEADERS
        expect(response).to have_http_status(201)
      end

      it 'should not return an error when user does not belongs to the group but group batchleader ' do
        sign_in(batch_leader)
        post '/api/v1/weekly-todo', params: parameters_create.to_json, headers: HEADERS
        expect(response).to have_http_status(201)
      end
    end

    context ' Authoize Update (errors) ' do
      it 'returns an error when user does not belongs to the group and not an admin or group_owner or group_co_owner ' do
        sign_in(user2)
        put "/api/v1/weekly-todo/#{wt1.id}", params: parameters_update.to_json, headers: HEADERS
        expect(response).to have_http_status(403)
      end

      it 'returns an error when user does belongs to the group and not an admin or group_owner or group_co_owner ' do
        sign_in(user1)
        put "/api/v1/weekly-todo/#{wt1.id}", params: parameters_update.to_json, headers: HEADERS
        expect(response).to have_http_status(403)
      end

      it 'should return an error when passing creation_week' do
        sign_in(admin)
        parameters_update[:data][:attributes][:creation_week] = Date.current

        put "/api/v1/weekly-todo/#{wt1.id}", params: parameters_update.to_json, headers: HEADERS
        expect(response).to have_http_status(400)
        expect(JSON.parse(response.body, symbolize_names: true)[:errors][0][:detail]).to eq('creation_week is not allowed.')
      end

      it 'should return an error when passing creation_week' do
        sign_in(admin)
        parameters_update[:data][:attributes][:group_id] = 1

        put "/api/v1/weekly-todo/#{wt1.id}", params: parameters_update.to_json, headers: HEADERS
        expect(response).to have_http_status(400)
        expect(JSON.parse(response.body, symbolize_names: true)[:errors][0][:detail]).to eq('group_id is not allowed.')
      end
    end

    context ' Authoize Update (should not return an error) ' do
      it 'returns no error when user does not belongs to the group but an admin ' do
        sign_in(admin)
        put "/api/v1/weekly-todo/#{wt1.id}", params: parameters_update.to_json, headers: HEADERS
        expect(response).to have_http_status(200)
      end

      it 'returns no error when user is the group_owner ' do
        sign_in(owner)
        put "/api/v1/weekly-todo/#{wt1.id}", params: parameters_update.to_json, headers: HEADERS
        expect(response).to have_http_status(200)
      end

      it 'returns no error when user is the group_co_owner ' do
        sign_in(co_owner)
        put "/api/v1/weekly-todo/#{wt1.id}", params: parameters_update.to_json, headers: HEADERS
        expect(response).to have_http_status(200)
      end
    end

    context 'Authorize streak' do
      it 'returns error when user does not belongs to the group and nither an admin nor the group batchleader' do
        sign_in(user2)
        get "/api/v1/weekly-todo/#{group1.id}/streak", params: parameters_index, headers: HEADERS
        expect(response).to have_http_status(403)
      end

      it 'returns no error when user does belongs to the group' do
        sign_in(user1)
        get "/api/v1/weekly-todo/#{group1.id}/streak", params: parameters_index, headers: HEADERS
        expect(response).to have_http_status(200)
      end

      it 'returns no error when user does not belongs to the group but an admin ' do
        sign_in(admin)
        get "/api/v1/weekly-todo/#{group1.id}/streak", params: parameters_index, headers: HEADERS
        expect(response).to have_http_status(200)
      end

      it 'returns no error when user does not belongs to the group but group batchleader ' do
        sign_in(batch_leader)
        get "/api/v1/weekly-todo/#{group1.id}/streak", params: parameters_index, headers: HEADERS
        expect(response).to have_http_status(200)
      end
    end
  end
end
