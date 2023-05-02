# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::Admin::ProjectsController, type: :request do
  let(:user) { create(:user, name: 'user1', user_type: 1) }
  let(:backend_challenge) { create(:backend_challenge, name: 'test_challenge', challenge_type: 'stackblitz', user_id: user.id) }

  before :each do
    sign_in(user)
  end

  context 'create action' do
    it 'should not create a project if the challenge_type is invalid' do
      params = {
        "data": {
          "type": 'projects',
          "attributes": {
            "challenge_id": backend_challenge.id,
            "challenge_type": SecureRandom.hex(3)
          }
        }
      }

      post '/api/v1/admin/projects', params: params.to_json, headers: HEADERS
      expect(response.status).to eq(404)
      expect(Project.count).to eq(0)
    end

    it 'should not create a project if it already exists' do
      params = {
        "data": {
          "type": 'projects',
          "attributes": {
            "challenge_id": backend_challenge.id,
            "challenge_type": 'BackendChallenge'
          }
        }
      }

      Project.create(challenge_id: backend_challenge.id, challenge_type: 'BackendChallenge')

      post '/api/v1/admin/projects', params: params.to_json, headers: HEADERS
      expect(response.status).to eq(400)
      expect(Project.count).to eq(1)
    end

    it 'should create a project' do
      params = {
        "data": {
          "type": 'projects',
          "attributes": {
            "challenge_id": backend_challenge.id,
            "challenge_type": 'BackendChallenge'
          }
        }
      }

      post '/api/v1/admin/projects', params: params.to_json, headers: HEADERS
      expect(response.status).to eq(201)
      expect(Project.count).to eq(1)
    end
  end
end
