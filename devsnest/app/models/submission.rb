# frozen_string_literal: true

class Submission < ApplicationRecord
  enum status: %i[done notdone doubt]

  def self.create_submission(user_id, content_id, choice)
    submission = Submission.find_by(user_id: user_id, content_id: content_id)
    user = User.find(user_id)

    unless submission.present?
      Submission.create(user_id: user_id, content_id: content_id, status: choice)
      user.score = 0 if user.score.nil?

      user.score += 10 if choice.zero?
      user.save
      return
    end

    user.score -= 10 if (submission.status == 'done') && (choice != 0)

    user.score += 10 if (submission.status == 'notdone') && choice.zero?

    submission.status = choice
    submission.save
    user.save
    nil
  end
end
