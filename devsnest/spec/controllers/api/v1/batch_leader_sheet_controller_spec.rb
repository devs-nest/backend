# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::BatchLeaderSheetController, type: :controller do
  before { allow(controller).to receive(:user_auth).and_return(true) }
  let(:current_user) { create(:user) }

  controller do
    def test_authorize_sheet_index
      authorize_sheet
    end
  end

  controller do
    def test_authorize_sheet_update
      authorize_sheet
    end
  end

  controller do
    def test_authorize_create
      authorize_create
    end
  end

  controller do
    def test_check_updatable_sheet
      check_updatable_sheet
    end
  end

  describe 'test_batch_leader_sheet' do
    let(:parameters_index) do
      {
        "group_id": group.id,
        "date": '2021-06-19',
        "controller": 'api/v1/batch_leader_sheet',
        "action": 'index'
      }
    end

    let(:parameters_update) do
      {
        "data":
        {
          "id": batch_leader_sheet.id
        },
        "action": 'update'
      }
    end
    
    let(:parameters_create) do
      {
        "data":
        {
            "attributes":
            {
                "user_id": user.id,
                "group_id": group.id,
                "active_members": [],
                "par_active_members": [],
                "inactive_members":
                [
                    'lakshit',
                    'naman'
                ],
                "extra_activity": [],
                "doubt_session_taker": []
            },
            "type": 'batch_leader_sheets'
        }
    }
    end
    let(:parameters_check) do
      {
        'data': {
          "id": batchleadersheet.id
        }
      }
    end

    subject(:authorize_sheet_index) { controller.test_authorize_sheet_index }

    context 'authorize_sheet_index' do
      let(:group) { create(:group) }
      let(:user) { create(:user) }

      before { controller.instance_variable_set(:@current_user, user) }
      before { allow(controller).to receive(:params).and_return(parameters_index) }

      it 'checks if authorize_sheet_index returns error' do
        expect { authorize_sheet_index }.to raise_error
      end

      it 'checks if authorize_sheet_index returns no error if user is batch_leader' do
        group.update(batch_leader_id: user.id)
        expect(authorize_sheet_index).to be true
      end

      it 'checks if authorize_sheet_index returns no error if user is admin' do
        group.update(batch_leader_id: 0)
        user.update(user_type: 1)
        expect(authorize_sheet_index).to be true
      end
    end

    subject(:authorize_sheet_update) { controller.test_authorize_sheet_update }

    context 'authorize_sheet_update' do
      let(:group) { create(:group) }
      let(:user) { create(:user) }
      let(:batchleadersheet) { create(:batch_leader_sheet, user_id: user.id, group_id: group.id) }
      before { controller.instance_variable_set(:@current_user, user) }
      before { allow(controller).to receive(:params).and_return(parameters_index) }
      
      it 'checks if authorize_sheet_update returns error' do
        expect { authorize_sheet_update }.to raise_error
      end

      it 'checks if authorize_sheet_update returns no error if user is batch_leader' do
        group.update(batch_leader_id: user.id)
        expect(authorize_sheet_update).to be true
      end

      it 'checks if authorize_sheet_update returns no error if user is admin' do
        group.update(batch_leader_id: 0)
        user.update(user_type: 1)
        expect(authorize_sheet_update).to be true
      end
    end
    
    subject(:authorize_create) { controller.test_authorize_create }

    context 'authorize_create' do
      before { allow(controller).to receive(:params).and_return(parameters_create) }
      let(:group) { create(:group) }
      let(:user) { create(:user) }

      it 'checks if authorize_create returns error' do
        expect { authorize_create }.to raise_error
      end

      it 'checks if authorize_create returns true' do
        group.update(batch_leader_id: user.id)
        expect(authorize_create).to be true
      end
    end

    subject(:check_updatable_sheet) { controller.test_check_updatable_sheet }

    context 'check_updatable_sheet' do
      before { allow(controller).to receive(:params).and_return(parameters_check) }
      let(:batchleadersheet) { create(:batch_leader_sheet) }

      it 'checks if check_sheet returns true' do
        expect(check_updatable_sheet).to be true
      end

      it 'checks if check_sheet returns error' do
        batchleadersheet.update(creation_week: (Date.current - 100.days).at_beginning_of_week)
        expect { check_updatable_sheet }.to raise_error
      end
    end
  end
end
