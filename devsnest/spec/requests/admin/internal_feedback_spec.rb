# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Internal_Feedback', type: :request do
  let(:user) { create(:user) }
  before :each do
    sign_in(user)
  end

  context 'Internal_Feedback - Permission Checks' do
    it 'If User is Admin' do
      user.update(user_type: 1)
      get '/api/v1/admin/internal-feedback'
      expect(response.status).to eq(200)
    end

    it 'If User is not Admin' do
      get '/api/v1/admin/internal-feedback'

      expect(response.status).to eq(401)
    end
  end

  context 'Internal Feedback - filter check' do
    it 'span filter should be applied' do
      user.update(user_type: 1)
      create(:internal_feedback, user: user, feedback_type: 'issue')
      get "/api/v1/admin/internal-feedback?filter[span]=#{Date.today}"
      expect(response.status).to eq(200)
      expect(Date.parse(JSON.parse(response.body)['data'][0]['attributes']['created_at'])).to eq(Date.today)
    end
  end

  context 'Internal Feedback issue type Fields check' do
    it 'fields when feedback_type is issue' do
      user.update(user_type: 1)
      create(:internal_feedback, user: user, feedback_type: 'issue')
      get '/api/v1/admin/internal-feedback?feedback_type=issue'
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['data'][0]['attributes']).not_to include(%i[group_activity_rating TL_rating VTL_rating group_morale obstacles_faced BL_availability
                                                                                   BL_rating comments_on_BL])
    end
  end

  context 'Internal Feedback group_feedback type Fields check' do
    it 'fields when feedback_type is group_feedback' do
      user.update(user_type: 1)
      create(:internal_feedback, user: user, feedback_type: 'group_feedback')
      get '/api/v1/admin/internal-feedback?feedback_type=group_feedback'
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['data'][0]['attributes']).not_to include(%i[problems_faced issue_scale issue_details solution BL_availability BL_rating comments_on_BL])
    end
  end

  context 'Internal Feedback batch_leader_feedback type Fields check' do
    it 'fields when feedback_type is batch_leader_feedback' do
      user.update(user_type: 1)
      create(:internal_feedback, user: user, feedback_type: 'batch_leader_feedback')
      get '/api/v1/admin/internal-feedback?feedback_type=batch_leader_feedback'
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['data'][0]['attributes']).not_to include(%i[problems_faced issue_scale issue_details solution group_activity_rating TL_rating VTL_rating group_morale
                                                                                   obstacles_faced])
    end
  end
end
