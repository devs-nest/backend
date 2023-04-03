# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Admin::BackendChallengeController, type: :request do
  let(:user) { create(:user, name: 'user1', user_type: 1) }
  let(:be_challenge) { create(:backend_challenge, user_id: user.id, name: 'todo list', challenge_type: 'stackblitz') }

  before :each do
    sign_in(user)
  end

  context 'GET - backend challenges' do
    it 'should return all the backend challenge' do
      get '/api/v1/admin/backend-challenge'
      expect(response.status).to eq(200)
    end

    it 'should return a backend challenge when id is provided' do
      get "/api/v1/admin/backend-challenge/#{be_challenge.id}"
      expect(response.status).to eq(200)
    end

    it 'should not return a backend challenge when the challenge is not found' do
      get '/api/v1/admin/backend-challenge/1201'
      expect(response.status).to eq(404)
    end

    it 'should return all the active challenges' do
      get '/api/v1/admin/backend-challenge/active-questions'
    end
  end
end
