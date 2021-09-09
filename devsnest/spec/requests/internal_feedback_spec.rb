# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::AdminController', type: :request do
  let(:user) { create(:user, discord_active: true) }
  let(:admin) { create(:user, user_type: 'admin') }
  let(:controller) { Api::V1::InternalFeedbackController }
  before :each do
    sign_in(user)
  end

  let(:parameters) do
    {
      "data": {
        "attributes": {
          "issue_type": 'User related',
          "issue_described": 'description',
          "feedback": 'feedback to admin or suggestion',
          "issue_scale": 8
        },
        "type": 'internal_feedbacks'
      }

    }
  end

  it 'post feedback when user has no previous_feedback' do
    post '/api/v1/internal-feedback', params: parameters.to_json, headers: HEADERS
    expect(response.status).to eq(201)
  end

  it 'post feedback when user has active cooldown' do
    create(:internal_feedback, user: user, created_at: Time.now - 2.days, updated_at: Time.now - 2.days)
    post '/api/v1/internal-feedback', params: parameters.to_json, headers: HEADERS
    expect(response.status).to eq(400)
    expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:error][:message]).to eq('Active cooldown for submitting new feedback : 5 days')
  end

  it 'post feedback when user has no cooldown' do
    create(:internal_feedback, user: user, created_at: Time.now - 8.days, updated_at: Time.now - 8.days)
    post '/api/v1/internal-feedback', params: parameters.to_json, headers: HEADERS
    expect(response.status).to eq(201)
  end
end
