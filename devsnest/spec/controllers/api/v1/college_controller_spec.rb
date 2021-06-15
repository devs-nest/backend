require 'rails_helper'

RSpec.describe Api::V1::CollegeController, type: :controller do
  before { allow(controller).to receive(:user_auth).and_return(true) }
  describe 'GET index' do
    it 'get the lists of all colleges' do
      get :index
      expect(response).to be_successful
    end
  end
end
