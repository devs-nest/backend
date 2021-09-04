# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BatchLeaderSheet, type: :request do
  context 'get batch_leader_sheets' do
    let(:group) { create(:group) }
    let(:user) { create(:user) }
    let(:batchleadersheet) { create(:batch_leader_sheet, creation_week: Date.current.at_beginning_of_week) }

    before :each do
      sign_in(user)
    end
    let(:params) { { 'group_id': group.id, 'date': Date.current } }

    it 'should return the Batch_leader_sheet if the user is batch leader of group' do
      batchleadersheet.update(user_id: user.id, group_id: group.id)
      group.update(batch_leader_id: user.id)

      get '/api/v1/batch-leader-sheet', params: params
      expect(response).to have_http_status(200)
    end

    it 'should return the Batch_leader_sheet if the user is admin' do
      group.update(batch_leader_id: 0)
      user.update(user_type: 1)

      get '/api/v1/batch-leader-sheet', params: params
      expect(response).to have_http_status(200)
    end
  end

  context 'errors check while getting batch_leader_sheets' do
    let(:group) { create(:group) }
    let(:user) { create(:user) }
    let(:batchleadersheet) { create(:batch_leader_sheet, creation_week: Date.current.at_beginning_of_week) }

    before :each do
      sign_in(user)
    end
    let(:params) { { 'group_id': group.id, 'date': Date.current } }

    it 'should return forbidden if the user is not admin and batch leader' do
      group.update(batch_leader_id: 0)
      user.update(user_type: 0)

      get '/api/v1/batch-leader-sheet', params: params
      expect(response).to have_http_status(403)
      expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:code]).to eq('forbidden')
    end

    it 'should return Bad Request if the group is not present' do
      params[:group_id] = 0

      get '/api/v1/batch-leader-sheet', params: params
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:error][:message]).to eq('Group Not Found')
    end
  end

  context 'create batch_leader_sheets' do
    let(:group) { create(:group) }
    let(:user) { create(:user) }

    before :each do
      sign_in(user)
    end

    let(:params) do
      {

        "data": {
          "attributes": {
            "user_id": user.id,
            "group_id": group.id,
            "inactive_members": %w[lakshit naman]
          },
          "type": 'batch_leader_sheets'
        }
      }
    end

    it 'should create the batch_leader_sheet if user is batch leader of that group' do
      group.update(batch_leader_id: user.id)

      post '/api/v1/batch-leader-sheet', params: params.to_json, headers: HEADERS
      expect(response).to have_http_status(201)
    end

    it 'should create the batch_leader_sheet if user is admin' do
      group.update(batch_leader_id: user.id)
      user.update(user_type: 1)

      post '/api/v1/batch-leader-sheet', params: params.to_json, headers: HEADERS
      expect(response).to have_http_status(201)
    end

    it 'should return error if user is not batchleader and not admin' do
      post '/api/v1/batch-leader-sheet', params: params.to_json, headers: HEADERS
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:error][:message]).to eq('You cannot Create this sheet')
    end

    it 'should return a error when passing creation_week' do
      group.update(batch_leader_id: user.id)
      params[:data][:attributes][:creation_week] = Date.current

      post '/api/v1/batch-leader-sheet', params: params.to_json, headers: HEADERS
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body, symbolize_names: true)[:errors][0][:detail]).to eq('creation_week is not allowed.')
    end
  end

  context 'update batch_leader_sheets when user is admin or barch_leader' do
    let(:group) { create(:group) }
    let(:user) { create(:user) }
    let(:batchleadersheet) { create(:batch_leader_sheet, user_id: user.id, group_id: group.id) }
    before :each do
      sign_in(user)
    end

    let(:params) do
      {
        "data": {
          "id": batchleadersheet.id,
          "attributes": {
            "inactive_members": %w[lakshit naman]
          },
          "type": 'batch_leader_sheets'
        }
      }
    end

    it 'should update the batch_leader_sheet if user is batch leader of that group' do
      group.update(batch_leader_id: user.id)

      put "/api/v1/batch-leader-sheet/#{batchleadersheet.id}", params: params.to_json, headers: HEADERS
      expect(response).to have_http_status(200)
    end

    it 'should update the batch_leader_sheet if user is admin' do
      user.update(user_type: 1)

      put "/api/v1/batch-leader-sheet/#{batchleadersheet.id}", params: params.to_json, headers: HEADERS
      expect(response).to have_http_status(200)
    end

    it 'should return a error when passing group_id when user is admin' do
      group.update(batch_leader_id: user.id)
      user.update(user_type: 1)
      params[:data][:attributes][:group_id] = 0

      put "/api/v1/batch-leader-sheet/#{batchleadersheet.id}", params: params.to_json, headers: HEADERS
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body, symbolize_names: true)[:errors][0][:detail]).to eq('group_id is not allowed.')
    end

    it 'should return a error when passing creation_week when user is admin' do
      group.update(batch_leader_id: user.id)
      user.update(user_type: 1)
      params[:data][:attributes][:creation_week] = 0

      put "/api/v1/batch-leader-sheet/#{batchleadersheet.id}", params: params.to_json, headers: HEADERS
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body, symbolize_names: true)[:errors][0][:detail]).to eq('creation_week is not allowed.')
    end

    it 'should return a error when updating previous batch leader sheet' do
      batchleadersheet.update(creation_week: Date.current - 8.days)
      user.update(user_type: 1)

      put "/api/v1/batch-leader-sheet/#{batchleadersheet.id}", params: params.to_json, headers: HEADERS
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:error][:message]).to eq('You cannot Update this sheet')
    end
  end

  context 'update batch_leader_sheets in not admin or batch_leader' do
    let(:group) { create(:group) }
    let(:user) { create(:user) }
    let(:batchleadersheet) { create(:batch_leader_sheet, user_id: user.id, group_id: group.id) }
    before :each do
      sign_in(user)
    end

    let(:params) do
      {
        "data": {
          "id": batchleadersheet.id,
          "attributes": {
            "inactive_members": %w[lakshit naman]
          },
          "type": 'batch_leader_sheets'
        }
      }
    end

    it 'should return forbidden if user is not batch leader and admin' do
      put "/api/v1/batch-leader-sheet/#{batchleadersheet.id}", params: params.to_json, headers: HEADERS
      expect(response).to have_http_status(403)
    end

    it 'should return a error when passing creation_week when user is not admin' do
      group.update(batch_leader_id: user.id)
      params[:data][:attributes][:creation_week] = Date.current

      put "/api/v1/batch-leader-sheet/#{batchleadersheet.id}", params: params.to_json, headers: HEADERS
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body, symbolize_names: true)[:errors][0][:detail]).to eq('creation_week is not allowed.')
    end

    it 'should return a error when passing user_id when user is not admin' do
      group.update(batch_leader_id: user.id)
      params[:data][:attributes][:user_id] = 1

      put "/api/v1/batch-leader-sheet/#{batchleadersheet.id}", params: params.to_json, headers: HEADERS
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body, symbolize_names: true)[:errors][0][:detail]).to eq('user_id is not allowed.')
    end

    it 'should return a error when passing group_id when user is not admin' do
      group.update(batch_leader_id: user.id)
      params[:data][:attributes][:group_id] = 0

      put "/api/v1/batch-leader-sheet/#{batchleadersheet.id}", params: params.to_json, headers: HEADERS
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body, symbolize_names: true)[:errors][0][:detail]).to eq('group_id is not allowed.')
    end
  end
end
