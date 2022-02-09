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

      it 'to get frontend-question for an admin' do
        user.update(user_type: 1)
        get '/api/v1/admin/frontend-question'
        expect(response).to have_http_status(200)
      end

      it 'to get a specific frontend-question for an admin' do
        user.update(user_type: 1)
        get "/api/v1/admin/frontend-question/#{frontend_question1.id}"
        expect(response).to have_http_status(200)
      end
    end

    context 'create frontend-questions' do
      let(:user) { create(:user) }
      let(:frontend_question1) { create(:frontend_question) }
      before :each do
        sign_in(user)
      end

      let(:params) do
        {
          "data": {
            "type": 'frontend_question',
            "attributes": {
              "question_markdown": 'Hey there is me',
              "template": 'react',
              "open_paths": %w[a b c],
              "template_files": { "/app.js": 'Hello There' }
            }
          }
        }
      end

      it 'should return an error if user not admin' do
        post '/api/v1/admin/frontend-question', params: params.to_json, headers: HEADERS
        expect(response).to have_http_status(401)
      end

      it 'to create frontend-question for an admin' do
        user.update(user_type: 1)
        post '/api/v1/admin/frontend-question', params: params.to_json, headers: HEADERS
        expect(response).to have_http_status(200)
      end
    end

    context 'Update frontend-questions' do
      let(:user) { create(:user) }
      let(:frontend_question1) { create(:frontend_question) }
      before :each do
        sign_in(user)
      end

      let(:params) do
        {
          "data": {
            "id": frontend_question1.id,
            "type": 'frontend_question',
            "attributes": {
              "question_markdown": 'Hey there is me',
              "template": 'react',
              "open_paths": %w[a b],
              "template_files": { "/app.js": 'Hello There' }
            }
          }
        }
      end

      it 'should return an error if user not admin' do
        put "/api/v1/admin/frontend-question/#{frontend_question1.id}", params: params.to_json, headers: HEADERS
        expect(response).to have_http_status(401)
      end

      it 'to create frontend-question for an admin' do
        user.update(user_type: 1)
        put "/api/v1/admin/frontend-question/#{frontend_question1.id}", params: params.to_json, headers: HEADERS
        expect(response).to have_http_status(200)
      end
    end
  end
end
