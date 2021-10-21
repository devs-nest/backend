# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::InternalFeedbackController', type: :request do
  let(:user) { create(:user, discord_active: true) }
  let(:admin) { create(:user, user_type: 'admin') }
  before :each do
    sign_in(user)
  end

  let(:parameters) do
    {
      "data": {
        "attributes": {
          "feedback_type": 'issue',
          "issue_details": 'description',
          "solution": 'feedback to admin or suggestion',
          "issue_scale": 8
        },
        "type": 'internal_feedbacks'
      }

    }
  end
  context 'Get Internal Feedback' do
    it 'check for the user specific feedbacks' do
      create(:internal_feedback, user: user)
      get '/api/v1/internal-feedback'
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['data'][0]['attributes']['user_id']).to eq(user.id)
    end
  end

  context 'Create Internal Feedbacks' do
    it 'check for the user specific feedbacks' do
      create(:internal_feedback, user: user, feedback_type: 'issue')
      create(:internal_feedback, user: user, feedback_type: 'issue')
      create(:internal_feedback, user: user, feedback_type: 'issue')
      create(:internal_feedback, user: user, feedback_type: 'issue')
      create(:internal_feedback, user: user, feedback_type: 'issue')
      post '/api/v1/internal-feedback', params: parameters.to_json, headers: HEADERS
      expect(response.status).to eq(400)
      expect(JSON.parse(response.body)['data']['attributes']['error']['message']).to eq('You can Only Create 5 feedbacks in 1 day of this type')
    end

    it 'Check Creation of Internal Feedback' do
      post '/api/v1/internal-feedback', params: parameters.to_json, headers: HEADERS
      expect(response.status).to eq(201)
    end
  end
end
