# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  before { allow(controller).to receive(:bot_auth).and_return(true) }
  let(:current_user) { create(:user) }

  controller do
    def test_onboard
      onboard
    end
  end

  describe 'Create User' do
    let(:parameters) do
      {
        data: {
          type: 'users',
          attributes: {
            discord_id: discord_id,
            email: 'test78@gmail.com'
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

  end

    describe 'Onboarding' do
      let(:parameters) do
        {
          "data": {
            "type": "onboards",
            "attributes": {
              "discord_username": "KayDee#8576",
              "discord_id": "1234567890",
              "name": "KayDee",
              "college": "TestGrp",
              "grad_year": 2,
              "work_exp": "2mnth",
              "known_from": "Friend",
              "dsa_skill": 4,
              "webd_skill":3
                         }
                 }
          }
      end
      
      subject(:check_onboard) { controller.test_onboard }

      context 'Check onboarding' do
        let(:action_params) { ActionController::Parameters.new(parameters) }
        before { controller.instance_variable_set(:@current_user, current_user) }
        before { allow(controller).to receive(:params).and_return(action_params) }
        before { allow(controller).to receive(:render_success) }


        it 'checks when user is not discord active' do
          expect {check_onboard }.to raise_error 
        end
        
        it "checks when user is discord active and haven't filled form yet" do
          current_user.discord_active = true
          expect { check_onboard }.to_not raise_error
        end

        it 'check when user already filled the form' do
          current_user.is_discord_form_filled = true
          expect { check_onboard }.to raise_error
        end

        it 'checks when user is already in a group' do
          group = create(:group)
          create(:group_member, user_id: current_user.id, group_id: group.id)
          expect { check_onboard }.to raise_error
        end
      end

    end



    
end
