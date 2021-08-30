# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InternalFeedback, type: :model do
  context 'check to_csv method' do
    let(:user) { create(:user) }

    it 'checks for empty csv' do
      feedback = create(:internal_feedback, user: user)
      InternalFeedback.to_csv
      expect(described_class.to_csv).to eq "id,user_id,user_name,issue_type,issue_described,feedback,issue_scale\n#{feedback.id},#{user.id},,Internal 1,This is the description,feedback for the team,#{feedback.issue_scale}\n"
    end
  end
end
