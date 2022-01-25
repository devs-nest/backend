# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Algo Editor Challenges', type: :request do
  let(:user) { create(:user, username: 'user1') }
  let!(:challenge1) { create(:challenge, user_id: user.id, name: 'two sum') }
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

  # context 'Testcases' do
  #   let(:params) do
  #     {
  #       "data": {
  #         "attributes": {
  #           "input_file": File.open("in.txt"),
  #           "output_file": File.open("in.txt"),
  #           "is_sample": true
  #         },
  #         "type": 'challenges'
  #       }
  #     }
  #   end

  #   it 'Adding test cases' do
  #     user.update(user_type: 1)
  #     post "/api/v1/admin/challenge/#{challenge1.id}/add_testcase"
  #     byebug
  #     expect(response.status).to eq(200)
  #   end

  #   # it 'If User is Problem setter' do
  #   #   user.update(user_type: 2)
  #   #   get '/api/v1/admin/challenge/self_created_challenges'
  #   #   expect(response.status).to eq(200)
  #   # end

  #   # it 'If User is not Admin' do
  #   #   get '/api/v1/admin/challenge'
  #   #   expect(response.status).to eq(401)
  #   # end
  # end
end
