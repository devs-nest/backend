require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  before { allow(controller).to receive(:bot_auth).and_return(true) }
  let(:current_user) { create(:user) }

  describe 'Create User' do
    let(:parameters) do
      {
        data: {
          type: 'users',
          attributes: {
            discord_id: discord_id,
            email:"test78@gmail.com"
                      }
              }
      }
    end

    context 'Check with Factory discord_id' do
      let(:discord_id) { current_user.discord_id }
        it 'POST with valid discord_id' do
          post :create, params: parameters
          expect(response).to have_http_status(200)
          expect(response).to be_successful
        end
    end

    context 'Check with Random discord_id' do
      let(:discord_id) { 2961438715638 }
        it 'POST with non-existence discord_id' do
          request.headers.merge!(HEADERS)
          post :create, params: parameters
          expect(response).to be_successful
          # rederecting to json_api | 201 created
          expect(response).to have_http_status(201)
        end
    end
  end
end
