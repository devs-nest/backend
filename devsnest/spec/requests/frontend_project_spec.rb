# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FrontendProject, type: :request do
  context 'get frontend projects' do
    let(:user) { create(:user) }
    let(:frontend_project) { create(:frontend_project, user_id: user.id) }

    # before :each do
    #   sign_in(user)
    # end
    let(:params) { { 'user_id': user.id } }

    it 'should return unauthorized if the user is not logged in' do
      get '/api/v1/frontend-project', params: params
      expect(response).to have_http_status(401)
    end

    it 'should return the frontend projects with the same user_id as provided in params' do
      sign_in(user)
      # Calling frontend project to load it
      frontend_project
      get '/api/v1/frontend-project', params: params
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:frontend_project].map { |project| project[:user_id] == user.id }.all?).to eq(true)
    end

    it 'should not return the frontend projects if the user_id in params and current_user does not match' do
      sign_in(user)
      get "/api/v1/frontend-project/#{frontend_project.name}", params: { 'user_id': user.id - 1 }
      expect(response).to have_http_status(401)
    end

    it 'should return the frontend project' do
      sign_in(user)
      get "/api/v1/frontend-project/#{frontend_project.name}", params: { 'user_id': user.id }
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:frontend_project][:user_id]).to eq(user.id)
    end
  end

  context 'create batch_leader_sheets' do
    let(:user) { create(:user) }

    before :each do
      sign_in(user)
    end

    let(:params) do
      {

        "data": {
          "type": 'frontend_projects',
          "attributes": {
            "name": 'test2',
            "template": 'react-ts',
            "template-files": {
              "/app.js": 'Hello'
            }
          }
        }
      }
    end

    it 'should create the frontend project' do
      post '/api/v1/frontend-project', params: params.to_json, headers: HEADERS
      expect(response).to have_http_status(201)
    end
  end

  context 'update frontend projects' do
    let(:user) { create(:user) }
    let(:frontend_project) { create(:frontend_project, user_id: user.id) }
    before :each do
      sign_in(user)
    end

    let(:params) do
      {

        "data": {
          "type": 'frontend_projects',
          "attributes": {
            "name": 'test2',
            "template": 'react-ts',
            "template-files": {
              "/app.js": 'Hello'
            }
          }
        }
      }
    end

    it 'should return not found if project name is invalid' do
      put "/api/v1/frontend-project/#{frontend_project.name}invalid", params: params.to_json, headers: HEADERS
      expect(response).to have_http_status(404)
    end

    it 'should retrurn unauthorized if the user_id in params and current_user does not match' do
      put "/api/v1/frontend-project/#{frontend_project.name}", params: params.to_json, headers: HEADERS
      expect(response).to have_http_status(401)
    end

    it 'should update the frontend project' do
      params['user_id'] = user.id

      put "/api/v1/frontend-project/#{frontend_project.name}", params: params.to_json, headers: HEADERS
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:frontend_project][:name]).to eq(params[:data][:attributes][:name])
    end
  end

  context 'Delete Frontend Projects in not admin or batch_leader' do
    let(:user) { create(:user) }
    let(:frontend_project) { create(:frontend_project, user_id: user.id) }
    before :each do
      sign_in(user)
    end

    let(:params) { { 'user_id': user.id } }

    it 'should return not found if project name is invalid' do
      delete "/api/v1/frontend-project/#{frontend_project.name}invalid", params: params.to_json, headers: HEADERS
      expect(response).to have_http_status(404)
    end

    it 'should retrurn unauthorized if the user_id in params and current_user does not match' do
      params['user_id'] = user.id - 1
      delete "/api/v1/frontend-project/#{frontend_project.name}", params: params.to_json, headers: HEADERS
      expect(response).to have_http_status(401)
    end

    it 'should delete the frontend project' do
      delete "/api/v1/frontend-project/#{frontend_project.name}", params: params.to_json, headers: HEADERS
      expect(response).to have_http_status(200)
      expect(FrontendProject.find_by(name: frontend_project.name, user_id: user.id)).to eq(nil)
    end
  end
end
