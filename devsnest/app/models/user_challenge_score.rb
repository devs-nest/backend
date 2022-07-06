# frozen_string_literal: true

class UserChallengeScore < ApplicationRecord
  belongs_to :user
  belongs_to :challenge

  after_commit :evaluate_scores

  def evaluate_scores

    all_user_subs_score = UserChallengeScore.where(user: user_id).sum {|a| a.score || 0}
    user.update(score: all_user_subs_score)
  end
end
