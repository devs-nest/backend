# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Notification', type: :request do
  context 'GET - Notification' do
    it 'should return all the notification' do
      get '/api/v1/notification'
      expect(response).to have_http_status(200)
    end
  end

  context 'POST - Notification' do
    it 'should create a notification' do
      params = {
        data: {
          attributes: {
            message: 'hi there!'
          },
          type: 'notifications'
        }
      }
      expect do
        post '/api/v1/notification', params: params.to_json, headers: HEADERS
      end.to change { Notification.count }.by(1)
      expect(response).to have_http_status(201)
    end
  end
end
