# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Certification', type: :request do
  let(:user) { create(:user) }
  before :each do
    sign_in(user)
  end

  context 'Certification - Permission Checks' do
    it 'If User is Admin' do
      user.update(user_type: 1)
      post '/api/v1/admin/certification', params: {
        "data": {
          "type": 'certifications',
          "attributes":
          {
            "user_id": user.id,
            "certificate_type": 'course_dsa'
          }
        }
      }.to_json, headers: HEADERS
      expect(response.status).to eq(201)
    end

    it 'If User is not Admin' do
      post '/api/v1/admin/certification', params: {
        "data": {
          "type": 'certifications',
          "attributes":
            {
              "user_id": user.id,
              "certificate_type": 'course_dsa'
            }
        }
      }.to_json, headers: HEADERS

      expect(response.status).to eq(401)
    end
  end
end
