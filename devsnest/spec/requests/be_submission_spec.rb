# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::BeSubmissionsController, type: :request do
  let(:user) { create(:user) }
  let(:be_challenge) { create(:backend_challenge, user_id: user.id, name: 'todo list', challenge_type: 'stackblitz') }
  let(:submission) { create(:be_submission, user_id: user.id, backend_challenge_id: be_challenge.id)}

  before :each do
    sign_in(user)
  end

  context 'GET - Backend challenge Submission' do
    it 'should get all submission' do
      get '/api/v1/be-submissions'
      expect(response.status).to eq(200)
    end

    it 'should get submission with specified id' do
      get "/api/v1/be-submissions/#{submission.id}"
      expect(response.status).to eq(200)
    end

    it 'should not return submission when it is not found' do
      get "/api/v1/be-submissions/#{submission.id}000"
      expect(response.status).to eq(404)
    end
  end
end
