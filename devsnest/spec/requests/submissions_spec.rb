# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Submission', type: :request do
  context 'create submission' do
    let(:user) { create(:user) }
    let(:content) { create(:content, unique_id: 'Q1') }

    let(:params) do
      {
        "data": {
          "attributes": {
            "discord_id": user.discord_id,
            "question_unique_id": content.unique_id,
            "status": 0
          },
          "type": 'submissions'
        }
      }
    end

    let(:bot_headers) do
      {
        'ACCEPT' => 'application/vnd.api+json',
        'CONTENT-TYPE' => 'application/vnd.api+json',
        'Token' => ENV['DISCORD_TOKEN'],
        'User-Type' => 'Bot'
      }
    end

    it 'should not create submission if user is not logged in' do
      post '/api/v1/submissions', params: params.to_json, headers: HEADERS
      expect(response).to have_http_status(401)
    end

    it 'should create submission if user is not logged in and user is submitting through bot' do
      post '/api/v1/submissions', params: params.to_json, headers: bot_headers
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:status]).to eq('done')
    end

    it 'should create submission if user is not logged in and user is submitting through bot' do
      post '/api/v1/submissions', params: params.to_json, headers: bot_headers
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:status]).to eq('done')
    end

    it 'should create submission when user is logged in and content doesnot exists' do
      sign_in(user)
      params[:data][:attributes][:question_unique_id] = 'Q999'
      post '/api/v1/submissions', params: params.to_json, headers: HEADERS
      expect(response).to have_http_status(400)
      expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:error]).to eq('User or Content not found')
    end

    it 'should create submission when user is logged in and content exists' do
      sign_in(user)
      post '/api/v1/submissions', params: params.to_json, headers: HEADERS
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:status]).to eq('done')
    end
  end
end
