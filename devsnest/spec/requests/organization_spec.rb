# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Organization', type: :request do
  context 'GET - Organizations' do
    let(:user) { create(:user) }
    let(:organization) { create(:organization) }

    it 'should not return organizations if user is not authenticated' do
      get '/api/v1/organization'
      expect(response).to have_http_status(401)
    end

    it 'should return all the organizations' do
      sign_in(user)
      get '/api/v1/organization'
      expect(response).to have_http_status(200)
    end

    it 'should return organization with specific id' do
      sign_in(user)
      get "/api/v1/organization/#{organization.id}"
      expect(response).to have_http_status(200)
    end

    it 'should not return an organization if it is not found' do
      sign_in(user)
      get '/api/v1/organization/0'
      expect(response).to have_http_status(404)
    end

    it 'should return an organization when fetched by its slug' do
      sign_in(user)
      organization.update!(slug: 'org_1')
      get '/api/v1/organization/fetch_by_slug?slug=org_1'
      expect(response).to have_http_status(200)
    end
  end
end
