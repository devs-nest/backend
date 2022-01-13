# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin for Froendend question creation', type: :request do
  context 'frontend-questions spec' do
    context 'get frontend-questions' do
      let(:user) { create(:user) }
      let(:frontend_question1) { create(:frontend_question) }
      before :each do
        sign_in(user)
      end

      it 'should return an error if user not admin' do
        get '/api/v1/admin/frontend-question'
        expect(response).to have_http_status(401)
      end

      it 'to get frontend-question for an admim' do
        user.update(user_type: 1)
        get '/api/v1/admin/frontend-question'
        expect(response).to have_http_status(200)
      end
    end
  end
end
