# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Company', type: :request do
  let(:user) { create(:user) }
  let(:company) { create(:company, name: 'Google', image_url: 'lol.xyz') }
  before :each do
    sign_in(user)
  end

  context 'Company - Permission Checks' do
    it 'If User is not Admin' do
      post '/api/v1/admin/company'

      expect(response.status).to eq(401)
    end

    it 'If User is not Admin' do
      put "/api/v1/admin/company/#{company.id}"

      expect(response.status).to eq(401)
    end
  end

  context 'Create Companies' do
    it 'should create a company' do
      user.update(user_type: 1)
      post '/api/v1/admin/company', params: {
        "name": 'Devsnest'
      }.to_json, headers: HEADERS
      expect(response.status).to eq(200)
    end

    it 'should update a company' do
      user.update(user_type: 1)
      put "/api/v1/admin/company/#{company.id}", params: {
        "id": company.id,
        "name": 'Devsnest-test'
      }.to_json, headers: HEADERS
      expect(response.status).to eq(200)
    end
  end
end
