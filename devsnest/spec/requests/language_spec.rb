# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::LanguageController', type: :request do
  let!(:user) { create(:user, discord_active: true) }
  let!(:language) { create(:language) }
  before :each do
    sign_in(user)
  end

  context 'Get All Languages' do
    it 'should get all languages' do
      get '/api/v1/language'
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['data'].count).to eq(Language.all.count)
    end
  end
end
