# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Organization', type: :request do
  let(:user) { create(:user) }

  before :each do
    sign_in(user)
  end

  context 'GET - Organizations' do
    let(:organization) { create(:organization) }

    it 'should not return organizations when user is not admin' do
      get '/api/v1/admin/organization'
      expect(response).to have_http_status(401)
    end

    it 'should return all the organizations' do
      user.update!(user_type: 1)
      get '/api/v1/admin/organization'
      expect(response).to have_http_status(200)
    end

    it 'should return an organization when id is provided' do
      user.update!(user_type: 1)
      get "/api/v1/admin/organization/#{organization.id}"
      expect(response).to have_http_status(200)
    end

    it 'should not return an orgazation if organization is not found with the id provided' do
      user.update!(user_type: 1)
      get '/api/v1/admin/organization/0'
      expect(response).to have_http_status(404)
    end
  end

  context 'POST - organization' do
    let(:params) do
      {
        data: {
          attributes: {
            name: 'organization 1',
            description: 'lorem ipsum'
          },
          type: 'organizations'
        }
      }
    end

    it 'should not create an organization if user is not admin' do
      expect do
        post '/api/v1/admin/organization', params: params.to_json, headers: HEADERS
      end.to change { Organization.count }.by(0)

      expect(response).to have_http_status(401)
    end

    it 'should create an organization' do
      user.update!(user_type: 1)
      expect do
        post '/api/v1/admin/organization', params: params.to_json, headers: HEADERS
      end.to change { Organization.count }.by(1)

      expect(response).to have_http_status(200)
    end
  end

  context 'UPDATE  - organization' do
    let(:organization) { create(:organization, name: 'test 1') }

    let(:params) do
      {
        data: {
          id: organization.id,
          attributes: {
            name: 'test 2'
          },
          type: 'organizations'
        }
      }
    end

    it 'should not update an organization if user is not admin' do
      put "/api/v1/admin/organization/#{organization.id}", params: params.to_json, headers: HEADERS
      expect(response).to have_http_status(401)
    end

    it 'should update an organization' do
      user.update!(user_type: 1)
      put "/api/v1/admin/organization/#{organization.id}", params: params.to_json, headers: HEADERS
      expect(response).to have_http_status(200)
    end
  end

  context 'DELETE - organization' do
    let!(:organization) { create(:organization) }

    it 'should not delete an organization if user is not admin' do
      expect do
        delete "/api/v1/admin/organization/#{organization.id}"
      end.to change { Organization.count }.by(0)

      expect(response).to have_http_status(401)
    end

    it 'should not delete an organization if it is not found' do
      user.update!(user_type: 1)
      expect do
        delete '/api/v1/admin/organization/0'
      end.to change { Organization.count }.by(0)

      expect(response).to have_http_status(404)
    end

    it 'should delete an organization' do
      user.update!(user_type: 1)
      expect do
        delete "/api/v1/admin/organization/#{organization.id}"
      end.to change { Organization.count }.by(-1)

      expect(response).to have_http_status(204)
    end
  end
end
