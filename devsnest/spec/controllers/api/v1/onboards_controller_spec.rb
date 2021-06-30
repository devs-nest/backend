# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::OnboardsController, type: :controller do
  before { allow(controller).to receive(:simple_auth).and_return(true) }
  
  let(:current_user) { create(:user) }

  controller do
    def test_register_user
      register_user
    end
  end

  controller do
    def test_check_discord
      check_discord
    end
  end

  controller do
    def test_check_group
      check_group
    end
  end

  controller do
    def test_update_user_profile
      update_user_profile
    end
  end


  describe 'Create User' do
    let(:parameters) do
      {
        "data": {
          "type": "onboards",
          "attributes": {
            "discord_username": "KayDee#8576",
            "discord_id":"1234567890",
            "name":"KayDee",
            "college":"TestGrp",
            "college_year":"2nd",
            "work_exp":"2mnth",
            "known_from":"Friend",
            "dsa_skill":4,
            "webd_skill":3
                       }
               }
        }
    end

    subject(:register_user) { controller.test_register_user }
  
    context 'register user' do
        before { controller.instance_variable_set(:@current_user, current_user) }
        before { allow(controller).to receive(:params).and_return(parameters) }
        it 'checks if register user returns error' do
          expect { register_user }.to_not raise_error
        end
        
        it 'checks if register user returns error' do
          create(:onboard, user_id: current_user.id)
          expect { register_user }.to raise_error
        end

    end

    subject(:check_discord) { controller.test_check_discord }

    context 'check discord' do
      before { controller.instance_variable_set(:@current_user, current_user) }
      before { allow(controller).to receive(:params).and_return(parameters) }
      it 'checks if register user returns error' do
        expect { check_discord }.to raise_error
      end
      
      it 'checks if register user returns error' do
        current_user.discord_active = true
        expect { check_discord }.to_not raise_error
      end
    end

    subject(:check_group) { controller.test_check_group }

    context 'check group' do
      before { controller.instance_variable_set(:@current_user, current_user) }
      before { allow(controller).to receive(:params).and_return(parameters) }
      it 'when user is not in any group' do
        expect { check_group }.to_not raise_error
      end

      it 'when user is in a group' do
        group = create(:group)
        create(:group_member, user_id: current_user.id, group_id: group.id)
        expect { check_group }.to raise_error
      end
    end

   subject(:update_user_profile) { controller.test_update_user_profile }

   context 'check user profile update' do
    before { controller.instance_variable_set(:@current_user, current_user) }
    before { allow(controller).to receive(:params).and_return(parameters) }

    it 'updates to existing group' do
      college = create(:college, name: parameters[:data][:attributes][:college])
      expect { update_user_profile }.to_not raise_error
      expect(current_user.college_id).to eq(college.id)
    end

   end   
  end
end
