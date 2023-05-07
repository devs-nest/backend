# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Referral', type: :request do
  context 'GET - Referral' do
    let(:user) { create(:user) }

    it 'should not return the referral when user is not logged in' do
      get '/api/v1/referral'
      expect(response).to have_http_status(401)
    end

    it 'should return all the referral' do
      sign_in(user)
      get '/api/v1/referral'
      expect(response).to have_http_status(200)
    end
  end
end
