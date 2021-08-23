# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::GroupsController, type: :request do
  context 'basic health_check' do
    it 'check health_check' do
      get '/health_check'
      expect(response.status).to eq(200)
    end
  end
end
