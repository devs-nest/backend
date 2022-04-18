# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Submission', type: :request do
  let!(:link1) { create(:link, slug: 'whatsapp', address: 'https://chat/lakgeflkqgef') }
  let!(:user) { create(:user) }
  let!(:user2) { create(:user, user_type: 1) }

  context 'Links perms check' do
    it 'should give an error if user is not admin' do
      get '/api/v1/admin/link'
      expect(response).to have_http_status(401)
    end

    it 'should get all the links if user i admin' do
      user.update(user_type: 1)
      sign_in(user)
      get '/api/v1/admin/link'
      expect(response).to have_http_status(200)
    end
  end

  context 'Links CRUD Check' do
    let(:link) { create(:link, slug: 'test', address: 'https://test.xyz') }
    let(:link_params) do
      {
        "data": {
          "attributes": {
            "slug": 'pdf',
            "address": 'https://lol.com'
          },
          "type": 'links'
        }
      }
    end
    it 'should give an error if user is not admin' do
      sign_in(user2)
      post '/api/v1/admin/link', params: link_params.to_json, headers: HEADERS
      expect(response).to have_http_status(201)
    end

    it 'should give an error if user is not admin' do
      sign_in(user2)
      delete "/api/v1/admin/link/#{link.slug}"
      expect(response).to have_http_status(204)
    end

    it 'should give an error if user is not admin' do
      sign_in(user2)
      put "/api/v1/admin/link/#{link.slug}", params: {
        "data": {
          "attributes": {
            "slug": link.slug,
            "address": 'https://lol.com'
          },
          "type": 'links'
        }
      }.to_json, headers: HEADERS
      expect(response).to have_http_status(204)
    end
  end
end
