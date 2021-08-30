# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Submission, type: :model do
  let(:user) { create(:user) }
  let(:submission) { create(:submission) }

  it "should call 'recalculate_all_scores' " do
    submission.update(status: 0, user_id: user.id)
    Submission.recalculate_all_scores
  end
end
