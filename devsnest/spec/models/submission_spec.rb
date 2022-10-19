# frozen_string_literal: true

# == Schema Information
#
# Table name: submissions
#
#  id         :bigint           not null, primary key
#  status     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  content_id :integer
#  user_id    :integer
#
# Indexes
#
#  index_submissions_on_user_id_and_content_id  (user_id,content_id) UNIQUE
#
require 'rails_helper'

RSpec.describe Submission, type: :model do
  let(:user) { create(:user) }
  let(:submission) { create(:submission) }

  it "should call 'recalculate_all_scores' " do
    submission.update(status: 0, user_id: user.id)
    Submission.recalculate_all_scores
  end
end
