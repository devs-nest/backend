# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EduEvent, type: :request do
  context 'EduEvent - request specs' do
    context 'get EduEvent' do
      let(:user) { create(:user) }
      let!(:edu_event) { create(:edu_event) }

      it 'should not return all the educational events if user is not logged in' do
        get '/api/v1/edu-events'
        expect(response).to have_http_status(401)
      end

      it 'should return all the educational events if user is logged in' do
        sign_in(user)

        get '/api/v1/edu-events'
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['data'].count).to eq(1)
      end

      it 'should get the details of a specific edu_events' do
        sign_in(user)

        get "/api/v1/edu-events/#{edu_event.id}"
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['data']['id'].to_i).to eq(edu_event.id)
        expect(JSON.parse(response.body)['data']['attributes']['current_user_registered']).to eq(false)
      end

      it 'should get the current_user_registered if the user is registered in the event' do
        sign_in(user)

        EventRegistration.create(user_id: user.id, edu_event_id: edu_event.id)
        get "/api/v1/edu-events/#{edu_event.id}"
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['data']['id'].to_i).to eq(edu_event.id)
        expect(JSON.parse(response.body)['data']['attributes']['current_user_registered']).to eq(true)
      end
    end
  end
end
