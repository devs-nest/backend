# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Coin Log', type: :request do
  context 'GET - Coin Log' do
    it 'should return the coin logs' do
      get '/api/v1/coin-logs'
      expect(response).to have_http_status(200)
    end
  end
end
