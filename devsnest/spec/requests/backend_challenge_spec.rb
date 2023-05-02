# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::BackendChallengeController, type: :request do
  let(:user) { create(:user) }
  let(:be_challenge) { create(:backend_challenge, user_id: user.id, name: 'todo list', challenge_type: 'stackblitz') }

  before :each do
    sign_in(user)
  end

  context 'GET - backend challenges' do
    it 'should return all the backend challenge' do
      get '/api/v1/backend-challenge'
      expect(response.status).to eq(200)
    end

    it 'should not return a backend challenge when the challenge is not found' do
      get '/api/v1/backend-challenge/1201'
      expect(response.status).to eq(404)
    end

    it 'should return a challenge when fetched by slug' do
      get "/api/v1/backend-challenge/fetch_by_slug?slug=#{be_challenge.slug}"
      expect(response.status).to eq(200)
    end

    it 'should not return a backend challenge when it is not found' do
      get "/api/v1/backend-challenge/fetch_by_slug?slug=#{SecureRandom.hex(3)}"
      expect(response.status).to eq(404)
    end
  end
end
