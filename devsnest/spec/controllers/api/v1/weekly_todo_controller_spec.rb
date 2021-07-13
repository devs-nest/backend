# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::WeeklyTodoController, type: :controller do
  before { allow(controller).to receive(:user_auth).and_return(true) }

  controller do
    def test_authorize_index
      authorize_index
    end
  end

  controller do
    def test_authorize_update
      authorize_update
    end
  end

  controller do
    def test_authorize_create
      authorize_create
    end
  end
  context 'Weeklytodo - controller specs' do
    let(:user1) { create(:user) }
    let(:user2) { create(:user) }
    let(:owner) { create(:user) }
    let(:co_owner) { create(:user) }
    let(:batch_leader) { create(:user) }
    let!(:admin) { create(:user, user_type: 1) }
    let(:group1) { create(:group, owner_id: owner.id, co_owner_id: co_owner.id, batch_leader_id: batch_leader.id) }
    let!(:group_member) { create(:group_member, user_id: user1.id, group_id: group1.id) }
    let!(:wt1) { create(:weekly_todo, group_id: group1.id) }
    let(:parameters_index) do
      {
        "group_id": group1.id,
        "controller": 'api/v1/batch_leader_sheet',
        "action": 'index'
      }
    end
    let(:parameters_create) do
      {
        "data": {
          "type": 'weekly_todos',
          "attributes": {
            "group_id": group1.id,
            "sheet_filled": false,
            "batch_leader_rating": 0,
            "extra_activity": 'null',
            "group_activity_rating": 0,
            "moral_status": 0,
            "obstacles": 'null',
            "comments": 'null',
            "todo_list": [
              {
                "title": 'Hey',
                "status": true
              }
            ]

          }
        }
      }
    end

    let(:parameters_update) do
      {

        "data": {
          "id": wt1.id,
          "type": 'weekly_todos',

          "attributes": {

            "sheet_filled": true,
            "batch_leader_rating": 0,
            "extra_activity": '',
            "group_activity_rating": 0,
            "moral_status": 0,
            "obstacles": '',
            "comments": '',
            "todo_list": [
              { "title": 'Added a new one',
                "status": true }
            ]
          }
        }

      }
    end

    subject(:authorize_sheet_index) { controller.test_authorize_index }
    context 'Authorize Index' do
      before { allow(controller).to receive(:params).and_return(parameters_index) }

      it 'return error when group id has an error' do
        allow(controller).to receive(:params).and_return({})
        controller.instance_variable_set(:@current_user, user1)
        expect { authorize_sheet_index }.to raise_error
      end

      it 'retruns error when user does not belongs to the group and nither an admin nor the group batchleader' do
        controller.instance_variable_set(:@current_user, user2)
        expect { authorize_sheet_index }.to raise_error
      end

      it 'retruns no error when user does belongs to the group' do
        controller.instance_variable_set(:@current_user, user1)
        expect { authorize_sheet_index }.to_not raise_error
      end

      it 'retruns no error when user does not belongs to the group but an admin ' do
        controller.instance_variable_set(:@current_user, admin)
        expect { authorize_sheet_index }.to_not raise_error
      end

      it 'retruns no error when user does not belongs to the group but group batchleader ' do
        controller.instance_variable_set(:@current_user, batch_leader)
        expect { authorize_sheet_index }.to_not raise_error
      end
    end

    subject(:authorize_create) { controller.test_authorize_create }
    context ' Authoize Create ' do
      before { allow(controller).to receive(:params).and_return(parameters_create) }
      it 'return error when group id has an error' do
        allow(controller).to receive(:params).and_return({})
        controller.instance_variable_set(:@current_user, user1)
        expect { authorize_create }.to raise_error
      end

      it 'retruns error when user does not belongs to the group and nither an admin nor the group batchleader' do
        controller.instance_variable_set(:@current_user, user2)
        expect { authorize_create }.to raise_error
      end

      it 'retruns no error when user does belongs to the group' do
        controller.instance_variable_set(:@current_user, user1)
        expect { authorize_create }.to_not raise_error
      end

      it 'retruns no error when user does not belongs to the group but an admin ' do
        controller.instance_variable_set(:@current_user, admin)
        expect { authorize_create }.to_not raise_error
      end

      it 'retruns no error when user does not belongs to the group but group batchleader ' do
        controller.instance_variable_set(:@current_user, batch_leader)
        expect { authorize_create }.to_not raise_error
      end
    end

    subject(:authorize_update) { controller.test_authorize_update }
    context ' Authoize Update ' do
      before { allow(controller).to receive(:params).and_return(parameters_update) }

      it 'return error when sheet id has an error' do
        allow(controller).to receive(:params).and_return({
                                                           "data": {
                                                             "id": wt1.id + 1,
                                                             "type": 'weekly_todos',
                                                             "attributes": {
                                                               "sheet_filled": true
                                                             }
                                                           }
                                                         })
        controller.instance_variable_set(:@current_user, owner)
        expect { authorize_update }.to raise_error
      end

      it 'retruns error when user does not belongs to the group and not an admin or group_owner or group_co_owner ' do
        controller.instance_variable_set(:@current_user, user2)
        expect { authorize_update }.to raise_error
      end

      it 'retruns error when user does belongs to the group and not an admin or group_owner or group_co_owner ' do
        controller.instance_variable_set(:@current_user, user1)
        expect { authorize_update }.to raise_error
      end

      it 'retruns no error when user does not belongs to the group but an admin ' do
        controller.instance_variable_set(:@current_user, admin)
        expect { authorize_update }.to_not raise_error
      end

      it 'retruns no error when user is the group_owner ' do
        controller.instance_variable_set(:@current_user, owner)
        expect { authorize_update }.to_not raise_error
      end

      it 'retruns no error when user is the group_co_owner ' do
        controller.instance_variable_set(:@current_user, co_owner)
        expect { authorize_update }.to_not raise_error
      end
    end
  end
end
