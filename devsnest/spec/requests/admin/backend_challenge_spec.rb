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

    it 'should not return a backend challenge when the challenge is not found' do
      get '/api/v1/admin/backend-challenge/1201'
      expect(response.status).to eq(404)
    end

    it 'should return all the active challenges' do
      get '/api/v1/admin/backend-challenge/active_questions'
      expect(response.status).to eq(200)
    end
  end

  context 'DELETE - backend challenge' do
    it 'should delete backend challenge with specified id' do
      delete "/api/v1/admin/backend-challenge/#{be_challenge.id}"

      allow($s3).to receive(:list_objects).and_return(true)
      expect(response.status).to eq(204)
    end

    it 'should not delete backend challenge if its not found' do
      delete "/api/v1/admin/backend-challenge/#{be_challenge.id}00000"
      expect(response.status).to eq(404)
    end
  end
end
