# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Algo Editor Challenges', type: :request do
  let(:user) { create(:user, username: 'user1') }
  let!(:challenge1) { create(:challenge, user_id: user.id, name: 'two sum') }
  let!(:testcase) { create(:testcase, challenge_id: challenge1.id) }
  let!(:company) { create(:company, name: 'Google') }
  let!(:company1) { create(:company, name: 'Microsoft') }
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

  context 'Testcases' do
    let(:params) do
      {
        "data": {
          "attributes": {
            "input_file": File.open('in.txt'),
            "output_file": File.open('in.txt'),
            "is_sample": true
          },
          "type": 'challenges'
        }
      }
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

    it 'Get all test cases' do
      user.update(user_type: 1)
      get "/api/v1/admin/challenge/#{challenge1.id}/testcases"
      expect(response.status).to eq(200)
    end

    it 'Adding test cases' do
      user.update(user_type: 1)
      post "/api/v1/admin/challenge/#{challenge1.id}/add_testcase"
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['data']['attributes']['message']).to eq('Testcase created successfully')
    end

    it 'Updating test cases' do
      user.update(user_type: 1)
      put "/api/v1/admin/challenge/#{challenge1.id}/update_testcase?testcase_id=#{testcase.id}"
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['data']['attributes']['message']).to eq('Testcase updated successfully')
    end

    it 'Deleting test cases' do
      user.update(user_type: 1)
      delete "/api/v1/admin/challenge/#{challenge1.id}/delete_testcase?testcase_id=#{testcase.id}"
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['data']['attributes']['message']).to eq('Testcase deleted successfully')
    end
  end

  context 'Company Tags' do
    let(:params) do
      {
        "data": {
          "type": 'companies',
          "attributes": {
            "companies": [
              'Microsoft'
            ]
          }
        }
      }
    end

    it 'Updating Company Tags to a challenge' do
      user.update(user_type: 1)
      CompanyChallengeMapping.create(challenge_id: challenge1.id, company_id: company.id)
      put "/api/v1/admin/challenge/#{challenge1.id}/update_company_tags", params: params
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['data']['attributes']['message']).to eq('Company Tags Updated Successfully')
    end
  end
end
