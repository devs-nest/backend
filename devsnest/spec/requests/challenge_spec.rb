# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Challenge, type: :request do
  context 'Challenge - request specs' do
    context 'get Content' do
      let(:user) { create(:user) }
      let(:question) { create(:challenge, user_id: user.id, name: 'two sum') }
      let(:algosub) { create(:algo_submission, user_id: user.id, challenge_id: question.id, status: 'Accepted', is_submitted: true) }

      it 'should return Challenges when exists' do
        get '/api/v1/challenge'
        expect(response).to have_http_status(200)
      end

      it 'should return Challenges when fetched by its slug' do
        get "/api/v1/challenge/fetch_by_slug?slug=#{question.name.parameterize}"
        expect(response).to have_http_status(200)
      end

      it 'should return Submission for the challenge' do
        sign_in(user)
        get "/api/v1/challenge/#{question.id}/submissions"
        expect(response).to have_http_status(200)
      end
    end
  end
end
