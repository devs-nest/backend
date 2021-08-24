# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Hackathon, type: :request do
  context 'Hackathon - request specs' do
    context 'get Hackathon' do
      let(:user) { create(:user) }

      it 'Should return Unauthorized when user is not logged in' do
        get '/api/v1/hackathon'
        expect(response.status).to eq(401)
        expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:code]).to eq('unauthorized')
      end

      it 'Should return Hackathon when user is logged in' do
        sign_in(user)
        get '/api/v1/hackathon'
        expect(response.status).to eq(200)
      end
    end

    context 'Create hackathon' do
      let(:user) { create(:user) }

      before :each do
        sign_in(user)
      end

      let(:params) do
        {
          "data": {
            "type": 'hackathons',
            "attributes": {
              "title": '2048 Game',
              "description": "The criteria for this hackathon would be how fun, elegant and intuitive. It should to play the game.\r\n\r\nthings which matter are:\r\n\r\n-well thought-off design."
              }
            }
          }
      end

      let(:headers) { { 'Content-Type' => 'application/vnd.api+json' } }

      it 'Should return Error if User is not admin' do
        post '/api/v1/hackathon', params: params.to_json, headers: headers
        expect(response.status).to eq(401)
        expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:code]).to eq('unauthorized')
      end

      it 'Should not return Error if User is admin' do
        user.update(user_type: 1)
        post '/api/v1/hackathon', params: params.to_json, headers: headers
        expect(response.status).to eq(201)
      end
    end

    context 'Update hackathon' do
      let(:user) { create(:user) }
      let(:hackathon) { create(:hackathon) }

      before :each do
        sign_in(user)
      end

      let(:params) do
        {
          "data": {
            "id": hackathon.id,
            "type": 'hackathons',
            "attributes": {
              "title": 'New Hackathon'
              }
            }
          }
      end

      let(:headers) { { 'Content-Type' => 'application/vnd.api+json' } }

      it 'Should return Error if User is not admin' do
        put "/api/v1/hackathon/#{hackathon.id}", params: params.to_json, headers: headers
        expect(response.status).to eq(401)
        expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:code]).to eq('unauthorized')
      end

      it 'Should return Error if User is not admin' do
        user.update(user_type: 1)
        put "/api/v1/hackathon/#{hackathon.id}", params: params.to_json, headers: headers
        expect(response.status).to eq(200)
      end
    end
  end
end
