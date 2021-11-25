# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Algo Editor Challenges', type: :request do
  let(:user) { create(:user) }
  before :each do
    sign_in(user)
  end

  context 'Algo Editor Challenges - Permission Checks' do
    it 'If User is Admin' do
      user.update(user_type: 1)
      get '/api/v1/admin/challenge'
      expect(response.status).to eq(200)
    end

    it 'If User is Problem setter' do
      user.update(user_type: 2)
      get '/api/v1/admin/challenge/self_created_challenges'
      expect(response.status).to eq(200)
    end

    it 'If User is not Admin' do
      get '/api/v1/admin/challenge'

      expect(response.status).to eq(401)
    end
  end
end
