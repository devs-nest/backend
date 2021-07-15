# frozen_string_literal: true

require "rails_helper"

RSpec.describe Api::V1::FrontendSubmissionsController, type: :controller do
  before { allow(controller).to receive(:user_auth).and_return(true) }

  controller do
    def test_check_submission
      check_submission
    end
  end

  describe "test_frontend_submissions" do
    let(:parameters) do
      {
        "data": {
          "attributes": {
            "question_unique_id": content.unique_id,
          },
          "type": "frontend_submissions",
        },

      }
    end

    subject(:check_submission) { controller.test_check_submission }

    context "check_submission" do
      let(:user) { create(:user) }
      before { controller.instance_variable_set(:@current_user, user) }
      before { allow(controller).to receive(:params).and_return(parameters) }
      let(:content) { create(:content, unique_id: "test") }

      it "checks if check_submission returns no error" do
        expect { check_submission }.to_not raise_error
      end

      it "checks if check_submission returns error" do
        content.update(unique_id: "test2")
        expect { check_submission }.to raise_error
      end
    end
  end
end
