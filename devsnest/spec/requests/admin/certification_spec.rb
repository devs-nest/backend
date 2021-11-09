# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Certification', type: :request do
  let(:user) { create(:user) }
  let(:params) do
    {
      "data": {
        "attributes": {
          "certificate_type": 'course_dsa',
          "discord_ids": [user.discord_id, 'invalid_discord_id']
        },
        "type": 'certifications'
      }
    }.to_json
  end
  before :each do
    sign_in(user)
  end

  context 'Certification - Permission Checks' do
    it 'If User is not Admin' do
      post '/api/v1/admin/certification', params: params, headers: HEADERS

      expect(response.status).to eq(401)
    end
  end

  context 'Get certificates' do
    it 'should return all the certificates' do
      Certification.create!(cuid: SecureRandom.base64(10).gsub('/', '_').gsub(/=+$/, ''), certificate_type: 'course_dsa', user_id: user.id)
      user.update(user_type: 1)
      get '/api/v1/admin/certification'

      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['data'][0]['attributes']['user_id']).to eq(user.id)
    end
  end
end
