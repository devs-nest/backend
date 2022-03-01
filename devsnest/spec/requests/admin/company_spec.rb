# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Company', type: :request do
  let(:user) { create(:user) }
  let(:company) { create(:company, name: 'Google', image_url: 'lol.xyz') }
  #   let(:params) do
  #     {
  #       "data": {
  #         "attributes": {
  #           "certificate_type": 'course_dsa',
  #           "discord_ids": [user.discord_id, 'invalid_discord_id']
  #         },
  #         "type": 'certifications'
  #       }
  #     }.to_json
  #   end
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
        "data": {
          "attributes": {
            "name": 'Devsnest'
          },
          "type": 'company'
        }
      }.to_json, headers: HEADERS
      expect(response.status).to eq(200)
    end

    it 'should update a company' do
      user.update(user_type: 1)
      put "/api/v1/admin/company/#{company.id}", params: {
        "data": {
          "id": company.id,
          "attributes": {
            "name": 'Devsnest-test'
          },
          "type": 'company'
        }
      }.to_json, headers: HEADERS
      expect(response.status).to eq(200)
    end
  end
end
