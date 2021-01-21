# frozen_string_literal: true

class Submission < ApplicationRecord
  enum status: %i[done notdone doubt]
  has_one :content

  def self.user_report(days, user_id)
    total_ques = Content.where(data_type: 0).count

    res = Content.joins(:submission).where(submissions: { status: 0, user_id: user_id }, contents: { data_type: 0 })
    total_solved_ques = res.count

    res = res.where({ updated_at: (Date.today - days)..(Date.today) }) if days.to_i.positive?
    res = res.select(:parent_id).group(:parent_id).count

    res['total_ques'] = total_ques
    res['total_solved_ques'] = total_solved_ques
    res
  end

  def self.create_submission(user_id, content_id, choice)
    submission = Submission.find_by(user_id: user_id, content_id: content_id)
    user = User.find(user_id)

    unless submission.present?

      submission = Submission.create(user_id: user_id, content_id: content_id, status: choice)
      user.score = 0 if user.score.nil?

      user.score += 1 if choice.zero?
      user.save
      return submission
    end

    user.score -= 1 if (submission.status == 'done') && (choice != 0)
    user.score += 1 if (submission.status == 'notdone') && choice.zero?

    submission.status = choice
    submission.save
    user.save
    submission
  end
end
