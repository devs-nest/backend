# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Company, type: :request do
  context 'Company - request specs' do
    context 'get Company' do
      let(:user) { create(:user) }
      let(:company) { create(:company) }

      it 'should return unauthorized when user is not logged in' do
        get '/api/v1/company'
        expect(response).to have_http_status(401)
      end

      it 'should return all companies when user is logged in' do
        sign_in(user)
        get '/api/v1/company'
        expect(response).to have_http_status(200)
      end
    end

    context 'Create Company' do
      let(:user) { create(:user) }
      let(:company) { create(:company) }

      before(:each) do
        sign_in(user)
      end

      let(:parameters) do
        {
          "data": {
            "attributes": {
              "name": 'Google'
            },
            "type": 'companies'
          }

        }
      end

      it 'should return unauthorized when user is not admin' do
        post '/api/v1/company', params: parameters.to_json
        expect(response).to have_http_status(401)
      end

      it 'should create the company when user is admin' do
        user.update(user_type: 1)
        post '/api/v1/company', params: parameters.to_json, headers: HEADERS
        expect(response).to have_http_status(201)
      end
    end
  end
end
