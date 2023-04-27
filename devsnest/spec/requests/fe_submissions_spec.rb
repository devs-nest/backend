# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::FeSubmissionsController, type: :request do
  let(:user) { create(:user) }
  let!(:course) { create(:course, name: 'Test Course') }
  let!(:course_curriculum) { create(:course_curriculum, course_id: course.id) }
  let(:challenge) do
    create(:frontend_challenge, name: 'Draw Face', day_no: '1', topic: 'html', difficulty: 'easy', question_body: '', user_id: user.id, course_curriculum_id: course_curriculum.id,
                                folder_name: 'draw-face', testcases_path: 'draw-face/testcases', active_path: 'index.html', open_paths: 'index.html', protected_paths: '/src/run.js',
                                hidden_files: '/src/test.js', template: 'js', challenge_type: 'frontend', files: [], score: 100)
  end
  let(:challenge_id) { challenge.id }

  context 'when the user is authenticated' do
    it 'creates a new fe_submission' do
      sign_in(user)
      expect do
        post '/api/v1/fe-submissions', params: {
          data: {
            type: 'fe_submissions',
            attributes: {
              'user_id': user.id,
              'frontend_challenge_id': challenge_id,
              'total_test_cases': 5,
              'passed_test_cases': 2,
              'score': 100,
              'question_type': 'local',
              'is_submitted': true
            }
          }
        }.to_json, headers: HEADERS
      end.to change(FeSubmission, :count).by(1)
      expect(response).to have_http_status(:created)
    end
    it 'updates the highest score' do
      sign_in(user)
      post '/api/v1/fe-submissions', params: {
        data: {
          type: 'fe_submissions',
          attributes: {
            'user_id': user.id,
            'frontend_challenge_id': challenge_id,
            'total_test_cases': 10,
            'passed_test_cases': 2,
            'score': 100,
            'question_type': 'local',
            'is_submitted': true
          }
        }
      }.to_json, headers: HEADERS
      sign_in(user)
      post '/api/v1/fe-submissions', params: {
        data: {
          type: 'fe_submissions',
          attributes: {
            'user_id': user.id,
            'frontend_challenge_id': challenge_id,
            'total_test_cases': 20,
            'passed_test_cases': 19,
            'score': 100,
            'question_type': 'local',
            'is_submitted': true
          }
        }
      }.to_json, headers: HEADERS
      expect(response).to have_http_status(:created)
    end
  end

  context 'when the user is not authenticated' do
    it 'returns unauthorized status' do
      post '/api/v1/fe-submissions', params: {
        data: {
          type: 'fe_submissions',
          attributes: {
            'user_id': user.id,
            'frontend_challenge_id': challenge_id,
            'total_test_cases': 5,
            'passed_test_cases': 5,
            'score': 100,
            'question_type': 'local',
            'is_submitted': true
          }
        }
      }.to_json, headers: HEADERS
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
