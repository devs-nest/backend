# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FrontendSubmission, type: :request do
  context 'create frontend submission' do
    let(:user) { create(:user) }
    let(:content) { create(:content, unique_id: 'Q1') }
    let!(:content2) { create(:content, unique_id: 'Q2') }
    let!(:frontsub) { create(:frontend_submission, user_id: user.id, content_id: content.id, submission_link: 'https://github.com/testing') }
    before(:each) do
      sign_in(user)
    end
    let(:params) do
      {
        "data": {
          "attributes": {
            "question_unique_id": 'Q1',
            "submission_link": 'https://github.com/testing'
          },
          "type": 'frontend_submissions'
        }
      }
    end

    it 'should create a new submission' do
      post '/api/v1/frontend-submissions', params: {
        "data": {
          "attributes": {
            "question_unique_id": 'Q2',
            "submission_link": 'https://github.com/testing'
          },
          "type": 'frontend_submissions'
        }
      }.to_json, headers: HEADERS
      expect(response).to have_http_status(201)
      body = JSON.parse(response.body, symbolize_names: true)
      expect(body[:data][:attributes][:submission_link]).to eq(params[:data][:attributes][:submission_link])
    end

    it 'update an existing submission' do
      FrontendSubmission.update(submission_link: 'https://github.com/updated')
      post '/api/v1/frontend-submissions', params: params.to_json, headers: HEADERS
      expect(response).to have_http_status(:ok)
      body = JSON.parse(response.body, symbolize_names: true)
      expect(body[:data][:attributes][:submission_link]).to eq(params[:data][:attributes][:submission_link])
    end

    it 'check if content is not present' do
      post '/api/v1/frontend-submissions', params: {
        "data": {
          "attributes": {
            "question_unique_id": 'Q76',
            "submission_link": 'https://github.com/testing'
          },
          "type": 'frontend_submissions'
        }
      }.to_json, headers: HEADERS
      expect(response).to have_http_status(400)
    end
  end
end
