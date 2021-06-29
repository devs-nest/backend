require 'rails_helper'

RSpec.describe Api::V1::OnboardsController, type: :controller do
  before { allow(controller).to receive(:simple_auth).and_return(true) }
  let(:current_user) { create(:user) }
  #before { controller.stub(:@current_user) { current_user } }
  #before { controller.instance_variable_set(:@current_user, current_user) }


  describe 'Create User' do
    let(:parameters) do
        {
            "data": {
              "type": "onboards",
              "attributes": {
                "discord_username": "KayDee#8576",
                "discord_id":"1234567890",
                "name":"KayDee",
                "college":"lol",
                "college_year":"2nd",
                "work_exp":"2mnth",
                "known_from":"Friend",
                "dsa_skill":4,
                "webd_skill":3
              }
            }
          }
    end
  
    describe 'Post' do
        
        it 'post a new form' do
            byebug
            request.headers.merge!(HEADERS)
            post :create, params: parameters
            expect(response).to be_successful
        end
    end
  end
end
