# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Frontend question creation', type: :request do
  context 'frontend-questions spec' do
    context 'get frontend-questions' do
      let(:user) { create(:user) }
      let(:frontend_question1) { create(:frontend_question) }

      it 'should not return the frontend question when user is not logged in' do
        get "/api/v1/frontend-questions/#{frontend_question1.id}"
        expect(response).to have_http_status(401)
      end

      it 'should return the frontend question' do
        sign_in(user)
        get "/api/v1/frontend-questions/#{frontend_question1.id}"
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['data']['id'].to_i).to eq(frontend_question1.id)
      end
    end
  end
end
