# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::Submission', type: :request do
  let!(:link1) { create(:link, slug: 'whatsapp', address: 'https://chat/lakgeflkqgef') }

  context 'Links Check' do
    it 'should give a context not found error if tried to fetch worng link' do
      get '/api/v1/link/facebook'
      expect(response).to have_http_status(404)
    end
    it 'should give a link if it exists' do
      get '/api/v1/link/whatsapp'
      expect(response).to have_http_status(200)
      expect(JSON.parse(response.body, symbolize_names: true)[:data][:attributes][:address]).to eq(link1.address)
    end
  end
end
