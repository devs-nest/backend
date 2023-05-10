# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Skill', type: :request do
  let(:user) { create(:user) }

  before :each do
    sign_in(user)
  end

  context 'GET - Skills' do
    it 'should not return the skills if user is not authenticated' do
      sign_out(user)
      get '/api/v1/skill'
      expect(response).to have_http_status(401)
    end

    it 'should return all the skills' do
      get '/api/v1/skill'
      expect(response).to have_http_status(200)
    end
  end

  context 'POST - skills' do
    let(:params) do
      {
        data: {
          attributes: {
            name: [['react', 'react logo']]
          },
          type: 'skills'
        }
      }
    end

    it 'should not create a skill if user is not admin' do
      expect do
        post '/api/v1/skill', params: params.to_json, headers: HEADERS
      end.to change { Skill.count }.by(0)
      expect(response).to have_http_status(401)
    end

    it 'should create a skill' do
      user.update!(user_type: 1)
      expect do
        post '/api/v1/skill', params: params.to_json, headers: HEADERS
      end.to change { Skill.count }.by(1)
      expect(response).to have_http_status(200)
    end
  end

  context 'DELETE - skills' do
    let!(:skill) { create(:skill, name: 'test skill') }

    it 'should not delete a skill if user is not admin' do
      expect do
        delete "/api/v1/skill/#{skill.id}"
      end.to change { Skill.count }.by(0)
      expect(response).to have_http_status(401)
    end

    it 'should delete a skill' do
      user.update!(user_type: 1)
      params = {
        data: {
          attributes: {
            name: ['test skill']
          }
        }
      }

      expect do
        delete "/api/v1/skill/#{skill.id}", params: params.to_json, headers: HEADERS
      end.to change { Skill.count }.by(-1)

      expect(response).to have_http_status(200)
    end
  end
end
