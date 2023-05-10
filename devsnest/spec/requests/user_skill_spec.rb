# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'UserSkill', type: :request do
  let(:user) { create(:user) }
  let(:skill) { create(:skill) }

  before :each do
    sign_in(user)
  end

  context 'GET - UserSkill' do
    it 'should return the skills of current user' do
      get '/api/v1/user-skill'
      expect(response).to have_http_status(200)
    end

    it 'should not return skills if user is not logged in' do
      sign_out(user)
      get '/api/v1/user-skill'
      expect(response).to have_http_status(401)
    end
  end

  context 'POST - UserSkill' do
    it 'should create a new user skill' do
      params = {
        data: {
          attributes: {
            skills: [
              {
                skill_id: skill.id,
                level: 1
              }
            ]
          }
        }
      }

      post '/api/v1/user-skill', params: params.to_json, headers: HEADERS
      expect(response).to have_http_status(200)
    end

    it 'should not create a new user skill with invalid level' do
      params = {
        data: {
          attributes: {
            skills: [
              {
                skill_id: skill.id,
                level: -10
              }
            ]
          }
        }
      }

      post '/api/v1/user-skill', params: params.to_json, headers: HEADERS
      expect(response).to have_http_status(400)
    end
  end
end
