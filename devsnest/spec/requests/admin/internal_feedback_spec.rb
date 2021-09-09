# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Internal_Feedback', type: :request do
  let(:user) { create(:user) }

  context 'Internal_Feedback - Permission Checks' do
    before :each do
      sign_in(user)
    end

    it 'If User is not Admin' do
      get '/api/v1/admin/internal-feedback'
      expect(response.status).to eq(401)
    end

    it 'If User is Admin' do
      user.update(user_type: 1)
      get '/api/v1/admin/internal-feedback'
      expect(response.status).to eq(200)
    end
  end
end
