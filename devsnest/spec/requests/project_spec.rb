# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::ProjectsController, type: :request do
  let(:user) { create(:user, name: 'user1') }

  before :each do
    sign_in(user)
  end

  context 'completed' do
    let(:frontend_challenge) { create(:frontend_challenge, name: 'test_challenge', is_project: true, user_id: user.id) }
    let(:fe_submission) { create(:fe_submission, frontend_challenge_id: frontend_challenge.id, user_id: user.id, total_test_cases: 1, passed_test_cases: 1) }

    let(:backend_challenge) { create(:backend_challenge, name: 'test_challenge', is_project: true, challenge_type: 'stackblitz', user_id: user.id) }
    let(:be_submission) { create(:be_submission, total_test_cases: 1, passed_test_cases: 1, user_id: user.id, backend_challenge_id: backend_challenge.id) }

    it 'should return all the completed projects' do
      get "/api/v1/projects/completed?username=#{user.username}"
      expect(response.status).to eq(200)
      count = 0

      Project.find_each do |project|
        case project.challenge_type
        when 'Article'
          count += ArticleSubmission.find_by(user_id: user.id, article_id: project.challenge_id).present?
        when 'BackendChallenge'
          count += BackendChallengeScore.find_by(user_id: user.id,
                                                 backend_challenge_id: project.challenge_id).where('passed_test_cases = total_test_cases').count
        when 'FrontendChallenge'
          count += FrontendChallengeScore.find_by(user_id: user.id,
                                                  frontend_challenge_id: project.challenge_id).where('passed_test_cases = total_test_cases').count
        end
      end

      expect(JSON.parse(response.body)['data']['attributes']['data'].count).to eq(count)
    end

    context 'GET projects' do
      it 'should return all the projects' do
        get '/api/v1/projects'
        expect(response.status).to eq(200)
      end
    end
  end
end
