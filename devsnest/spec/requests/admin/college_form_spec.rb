# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'College Form Spec', type: :request do
  context 'College form Check' do
    let(:user) { create(:user) }
    it 'should give an error if user is not admin' do
      get '/api/v1/admin/college-form'
      expect(response).to have_http_status(401)
    end

    it 'should return all the filled forms for admin' do
      user.update(user_type: 1)
      sign_in(user)
      get '/api/v1/admin/college-form'
      expect(response).to have_http_status(200)
    end
  end
end
