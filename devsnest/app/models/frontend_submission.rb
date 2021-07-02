# frozen_string_literal: true

class FrontendSubmission < ApplicationRecord
  has_one :content

  def self.create_submission(user_id, content_id, submission_link)
    submission = FrontendSubmission.find_by(user_id: user_id, content_id: content_id, submission_link: submission_link)
    user = User.find(user_id)

    unless submission.present?
      submission = FrontendSubmission.create(user_id: user_id, content_id: content_id, submission_link: submission_link )
    end
  end
end
