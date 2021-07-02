# frozen_string_literal: true

# frontend submission model
class FrontendSubmission < ApplicationRecord
  def self.create_submission(user_id, content_id, submission_link)
    submission = FrontendSubmission.find_by(user_id: user_id, content_id: content_id, submission_link: submission_link)

    unless submission.present?
      submission = FrontendSubmission.create(user_id: user_id, content_id: content_id, submission_link: submission_link)
    end
    submission
  end
end
