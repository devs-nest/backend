# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Course, type: :request do
  let(:user) { create(:user) }
  let!(:course) { create(:course, name: 'test') }
  before :each do
    sign_in(user)
  end

  context 'Course - Permission Checks' do
    it 'If User is not Admin' do
      get '/api/v1/admin/course'

      expect(response.status).to eq(401)
    end

    it 'If User is Admin' do
      user.update(user_type: 1)
      get '/api/v1/admin/course'

      expect(response.status).to eq(200)
    end
  end
end
