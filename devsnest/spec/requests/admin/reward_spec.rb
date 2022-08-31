# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Minibootcamp spec', type: :request do
  let(:user) { create(:user, user_type: 1) }
  let(:rewardee_user) { create(:user) }
  let(:params) do
    {
      "data": {
        "type": 'reward',
        "attributes": {
          "title": 'Reward for performance',
          "description": 'gg boi2',
          "user_id": rewardee_user.id,
          "coins": 25
        }
      }
    }
  end

  let(:params2) do
    {
      "data": {
        "type": 'reward',
        "attributes": {
          "title": 'Reward for performance',
          "description": 'gg boi2',
          "user_id": rewardee_user.id,
          "coins": 31
        }
      }
    }
  end

  before :each do
    sign_in(user)
  end

  context 'Provide reward points' do
    it 'gives reward' do
      post '/api/v1/admin/reward', params: params
      expect(response.status).to eq(200)

      sign_in(user)
      post '/api/v1/admin/reward', params: params
      expect(response.status).to eq(400)
    end
  end

  context 'Provide more than 30 reward points' do
    it 'gives reward invalid params' do
      post '/api/v1/admin/reward', params: params2
      expect(response.status).to eq(400)
    end
  end
end
