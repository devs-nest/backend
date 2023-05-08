# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EventRegistration, type: :request do
  context 'EventRegistration - request specs' do
    context 'Create EventRegistration' do
      let!(:user) { create(:user) }
      let!(:edu_event) { create(:edu_event) }
      let!(:params) do
        {
          "data": {
            "type": 'event-registration',
            "attributes": {
              "edu_event_id": edu_event.id,
              "user_data": {
                "name": 'Testing'
              }
            }
          }
        }.with_indifferent_access
      end

      it 'should not create a registration if user is not logged in' do
        post '/api/v1/event-registrations', params: params
        expect(response).to have_http_status(401)
      end

      it 'should not create a registration if edu event id is incorrect' do
        sign_in(user)

        params[:data][:attributes][:edu_event_id] = 0
        post '/api/v1/event-registrations', params: params
        expect(response).to have_http_status(404)
      end

      it 'should not create a registration if user is already registered' do
        sign_in(user)

        EventRegistration.create!(user_id: user.id, edu_event_id: edu_event.id)
        post '/api/v1/event-registrations', params: params
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)['data']['attributes']['message']).to eq('User Already Registered.')
      end

      it 'should create a registration if everything is correct' do
        sign_in(user)

        post '/api/v1/event-registrations', params: params
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['data']['attributes']['message']).to eq('Registered Successfully.')
      end
    end
  end
end
