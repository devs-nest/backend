# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Listmonk spec', type: :request do
  let(:user) { create(:user) }
  before :each do
    sign_in(user)
  end

  context 'Run list query' do
    it 'If User is not Admin' do
      get '/api/v1/admin/listmonk/list?condition=User.all'
      expect(response.status).to eq(401)
    end

    it 'If no condition is passed' do
      user.update(user_type: 1)
      get '/api/v1/admin/listmonk/list'
      expect(response.status).to eq(400)
    end

    it 'If condition doesnt return User' do
      user.update(user_type: 1)
      get '/api/v1/admin/listmonk/list?condition=Group.all'
      expect(response.status).to eq(422)
    end
  end
end
