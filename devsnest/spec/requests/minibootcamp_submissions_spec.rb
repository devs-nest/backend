# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Minibootcamp Submission', type: :request do
  let(:user) { create(:user) }
  let(:frontend_question1) { create(:frontend_question) }
  let(:minibootcamp_submission1) { create(:minibootcamp_submission, user_id: user.id, frontend_question_id: frontend_question1.id, is_solved: true) }

  context 'submissions check' do
    it 'should not create submission if user is not logged in' do
      post '/api/v1/minibootcamp-submissions', headers: HEADERS
      expect(response).to have_http_status(401)
    end

    it 'should get submission for a frontend question' do
      sign_in(user)
      get '/api/v1/minibootcamp-submissions', headers: HEADERS
      expect(response).to have_http_status(200)
    end
  end
end
