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
    user.score += 1 if (submission.status == 'notdone' || submission.status == 'doubt') && choice.zero?
    submission.status = choice
    submission.save
    user.save
    submission
  end

  def self.merge_submission(temp_user,user)
    temp_user_submission = Submission.where(discord_id: discord_id)
    temp_user_submission.each do |element|
      Submission.update(user_id: user.id, content_id: element.content_id, status:  element.status)
    end
    temp_user_submission.destroy_all
  end

  def self.recalculate_all_scores
    User.update_all(score: 0)
    sub_stats = Submission.where(status: 0).group(:user_id).count
    user_ids = sub_stats.keys
    user_ids.each do |user_id|
      user = User.find_by(id: user_id)
      user.score = sub_stats[user.id]
      user.save
    end
  end

  def self.count_solved(user_id)
    content_ids = Submission.where(user_id: user_id, status: 0).pluck(:content_id)
    Content.where(id: content_ids).group(:difficulty).count
  end

  def self.user_activity(user_id)
    Submission.where(status: %w[done doubt], user_id: user_id).group('DATE(updated_at)').count
  end
end
