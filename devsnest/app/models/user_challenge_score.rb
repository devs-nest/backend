# frozen_string_literal: true

class UserChallengeScore < ApplicationRecord
  belongs_to :user
  belongs_to :challenge

  after_commit :evaluate_scores

  def evaluate_scores
    challenge_ids = Challenge.where(id: challenge_ids, is_active: true)
    all_user_subs_score = UserChallengeScore.where(user: user_id, challenge_id: challenge_ids).sum {|a| a.score || 0} 
    user.update(score: all_user_subs_score)
  end
end
