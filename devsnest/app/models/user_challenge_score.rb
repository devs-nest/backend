# frozen_string_literal: true

class UserChallengeScore < ApplicationRecord
  belongs_to :user
  belongs_to :challenge

  after_commit :evaluate_scores

  def evaluate_scores
    all_user_subs = UserChallengeScore.where(user: user)
    user.update_column(:score, all_user_subs.map { |sub| sub[:score] }.inject(:+))
  end
end
