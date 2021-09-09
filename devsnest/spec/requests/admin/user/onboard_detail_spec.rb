# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Onboard_Details', type: :request do
  let(:user) { create(:user, discord_active: true) }

  before :each do
    sign_in(user)
  end

  context 'Onboard_Details - Permission Checks' do
    it 'If User is not Admin' do
      get '/api/v1/admin/users'
      expect(response.status).to eq(401)
    end

    it 'If User is Admin' do
      user.update(user_type: 1)
      get '/api/v1/admin/users'
      expect(response.status).to eq(200)
    end
  end

  context 'Onboard Details - filter check' do
    it 'Filter should be applied' do
      user.update(user_type: 1)
      get "/api/v1/admin/users?filter[span]=#{Date.today}"
      expect(response.status).to eq(200)
    end
  end
end
