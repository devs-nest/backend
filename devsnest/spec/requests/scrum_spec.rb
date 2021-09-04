# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Scrum, type: :request do
  context 'get Scrums basic errors ckecks checks' do
    let(:group) { create(:group) }
    let(:user) { create(:user) }
    let(:scrum) { create(:scrum) }
    let(:date) { Date.current }

    before :each do
      sign_in(user)
    end

    let(:params) { { 'group_id': group.id, 'date': date } }

    it 'should return error if Group is not present' do
      params['group_id'] = 0
      get '/api/v1/scrums', params: params
      expect(response.status).to eq(400)
      expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:error][:message]).to eq('Group Not Found')
    end

    it 'should return error if User is not member of group' do
      get '/api/v1/scrums', params: params
      expect(response.status).to eq(403)
      expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:code]).to eq('forbidden')
    end
  end

  context 'get Scrums (User checks)' do
    let(:group) { create(:group) }
    let(:user) { create(:user) }
    let(:scrum) { create(:scrum) }
    let(:group_member) { create(:group_member) }
    let(:date) { Date.current }

    before :each do
      sign_in(user)
    end

    let(:params) { { 'group_id': group.id, 'date': date } }

    it 'should not return error if User is member of group' do
      group.group_members.create(user_id: user.id, group_id: group.id)
      scrum.update(user_id: user.id, group_id: group.id)
      get '/api/v1/scrums', params: params
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body, symbolize_names: true)[:data][0][:attributes][:creation_date]).to eq(date.to_s)
    end

    it 'should not return error if User wants to see scrum history and user is member of group' do
      scrum.update(user_id: user.id, group_id: group.id, creation_date: Date.yesterday)
      group.group_members.create(user_id: user.id, group_id: group.id)
      params[:date] = Date.yesterday
      get '/api/v1/scrums', params: params
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body, symbolize_names: true)[:data][0][:attributes][:creation_date]).to eq(Date.yesterday.to_s)
    end
  end

  context 'get Scrums (Batch leader) checks' do
    let(:group) { create(:group) }
    let(:user) { create(:user) }
    let(:scrum) { create(:scrum) }
    let(:date) { Date.current }

    before :each do
      sign_in(user)
    end

    let(:params) { { 'group_id': group.id, 'date': date } }

    it 'should not return error if User is Batch Leader of group' do
      group.update(batch_leader_id: user.id)
      scrum.update(user_id: user.id, group_id: group.id)
      get '/api/v1/scrums', params: params
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body, symbolize_names: true)[:data][0][:attributes][:creation_date]).to eq(date.to_s)
    end

    it 'should not return error if User wants to see scrum history and user is batch_leader' do
      scrum.update(user_id: user.id, group_id: group.id, creation_date: Date.yesterday)
      group.update(batch_leader_id: user.id)
      params[:date] = Date.yesterday
      get '/api/v1/scrums', params: params
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body, symbolize_names: true)[:data][0][:attributes][:creation_date]).to eq(Date.yesterday.to_s)
    end
  end

  context 'get Scrums (Admin) checks' do
    let(:group) { create(:group) }
    let(:user) { create(:user) }
    let(:scrum) { create(:scrum) }
    let(:date) { Date.current }

    before :each do
      sign_in(user)
    end

    let(:params) { { 'group_id': group.id, 'date': date } }

    it 'should not return error if User is admin' do
      user.update(user_type: 1)
      scrum.update(user_id: user.id, group_id: group.id)
      get '/api/v1/scrums', params: params
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body, symbolize_names: true)[:data][0][:attributes][:creation_date]).to eq(date.to_s)
    end

    it 'should not return error if User wants to see scrum history and user is admin' do
      scrum.update(user_id: user.id, group_id: group.id, creation_date: Date.yesterday)
      user.update(user_type: 1)
      params[:date] = Date.yesterday
      get '/api/v1/scrums', params: params
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body, symbolize_names: true)[:data][0][:attributes][:creation_date]).to eq(Date.yesterday.to_s)
    end
  end

  context 'Create Scrums' do
    let(:group) { create(:group) }
    let(:user) { create(:user) }
    let(:scrum) { create(:scrum) }
    let(:group_member) { create(:group_member) }
    let(:date) { Date.current }

    before :each do
      sign_in(user)
    end

    let(:params) do
      {

        "data": {
          "attributes": {
            "user_id": user.id,
            "group_id": group.id,
            "saw_last_lecture": true,
            "topics_to_cover": 'dp'
          },
          "type": 'scrums'
        }
      }
    end

    it 'should create the scrum if user is admin' do
      user.update(user_type: 1)

      post '/api/v1/scrums', params: params.to_json, headers: HEADERS
      expect(response).to have_http_status(201)
    end

    it 'should create the scrum if user is batch_leader of group' do
      group.update(batch_leader_id: user.id)

      post '/api/v1/scrums', params: params.to_json, headers: HEADERS
      expect(response).to have_http_status(201)
    end

    it 'should create the scrum if user is group_member of group' do
      group.group_members.create(user_id: user.id, group_id: group.id)

      post '/api/v1/scrums', params: params.to_json, headers: HEADERS
      expect(response).to have_http_status(201)
    end

    it 'should not create the scrum if user is not the group_member of group' do
      post '/api/v1/scrums', params: params.to_json, headers: HEADERS
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:error][:message]).to eq('Permission Denied')
    end

    it 'should not create the scrum if attendence is passed in params and user is group_member of group' do
      group.group_members.create(user_id: user.id, group_id: group.id)
      params[:data][:attributes][:attendance] = 1
      post '/api/v1/scrums', params: params.to_json, headers: HEADERS
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body, symbolize_names: true)[:errors][0][:detail]).to eq('attendance is not allowed.')
    end
  end

  context 'Create Scrums' do
    let(:group) { create(:group) }
    let(:user) { create(:user) }
    let(:scrum) { create(:scrum, user_id: user.id, group_id: group.id) }
    let(:group_member) { create(:group_member) }
    let(:date) { Date.current }

    before :each do
      sign_in(user)
    end

    let(:params) do
      {

        "data":
        {
          "id": scrum.id,
          "attributes":
            {
              "saw_last_lecture": 'YsES',
              "topics_to_cover": 'dppefwp'
            },
          "type": 'scrums'
        }
      }
    end

    it 'should not update the previous days scrum' do
      scrum.update(creation_date: Date.yesterday)

      put "/api/v1/scrums/#{scrum.id}", params: params.to_json, headers: HEADERS
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:error][:message]).to eq('You Cannot Update this Scrum.')
    end

    it 'should not update if the user have no admin auths and user is not the owner of scrum' do
      scrum.update(user_id: 0)
      put "/api/v1/scrums/#{scrum.id}", params: params.to_json, headers: HEADERS
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:error][:message]).to eq('You Cannot Update this Scrum.')
    end

    it 'should update if the user is the owner of scrum' do
      put "/api/v1/scrums/#{scrum.id}", params: params.to_json, headers: HEADERS
      expect(response).to have_http_status(200)
    end

    it 'should update if the user is the admin' do
      scrum.update(user_id: 0)
      user.update(user_type: 1)

      put "/api/v1/scrums/#{scrum.id}", params: params.to_json, headers: HEADERS
      expect(response).to have_http_status(200)
    end

    it 'should update if the user is the batch leader of group' do
      scrum.update(user_id: 0)
      group.update(batch_leader_id: user.id)

      put "/api/v1/scrums/#{scrum.id}", params: params.to_json, headers: HEADERS
      expect(response).to have_http_status(200)
    end

    it 'should update if the user is the leader of group' do
      scrum.update(user_id: 0)
      group.update(owner_id: user.id)

      put "/api/v1/scrums/#{scrum.id}", params: params.to_json, headers: HEADERS
      expect(response).to have_http_status(200)
    end

    it 'should update if the user is the vice-leader of group' do
      scrum.update(user_id: 0)
      group.update(co_owner_id: user.id)

      put "/api/v1/scrums/#{scrum.id}", params: params.to_json, headers: HEADERS
      expect(response).to have_http_status(200)
    end

    it 'should update not take user_id in params' do
      params[:data][:attributes][:user_id] = user.id

      put "/api/v1/scrums/#{scrum.id}", params: params.to_json, headers: HEADERS
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body, symbolize_names: true)[:errors][0][:detail]).to eq('user_id is not allowed.')
    end

    it 'should update not take group_id in params' do
      params[:data][:attributes][:group_id] = group.id

      put "/api/v1/scrums/#{scrum.id}", params: params.to_json, headers: HEADERS
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body, symbolize_names: true)[:errors][0][:detail]).to eq('group_id is not allowed.')
    end

    it 'should update not take creation_date in params' do
      params[:data][:attributes][:creation_date] = date

      put "/api/v1/scrums/#{scrum.id}", params: params.to_json, headers: HEADERS
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body, symbolize_names: true)[:errors][0][:detail]).to eq('creation_date is not allowed.')
    end

    it 'should not take attendance in params if user has no admin rights' do
      params[:data][:attributes][:attendance] = date

      put "/api/v1/scrums/#{scrum.id}", params: params.to_json, headers: HEADERS
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body, symbolize_names: true)[:errors][0][:detail]).to eq('attendance is not allowed.')
    end

    it 'should take attendance in params if user has admin rights' do
      user.update(user_type: 1)
      params[:data][:attributes][:attendance] = date

      put "/api/v1/scrums/#{scrum.id}", params: params.to_json, headers: HEADERS
      expect(response).to have_http_status(200)
    end
  end
end
