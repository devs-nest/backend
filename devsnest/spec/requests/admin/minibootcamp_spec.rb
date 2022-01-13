# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Minibootcamp spec', type: :request do
  let(:user) { create(:user) }
  before :each do
    sign_in(user)
  end

  context 'Minibootcamp - Permission Checks' do
    it 'If User is Admin' do
      user.update(user_type: 1)
      get '/api/v1/admin/minibootcamp'
      expect(response.status).to eq(200)
    end
  end
end
