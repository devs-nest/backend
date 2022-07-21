# frozen_string_literal: true

class UcsEvaluateScoreWorker
  include Sidekiq::Worker

  def perform(user_id)
    challenge_ids = Challenge.where(is_active: true)
    user = User.find_by(id: user_id)
    all_user_subs_score = UserChallengeScore.where(user: user_id, challenge_id: challenge_ids).sum {|a| a.score || 0}
    user.update(score: all_user_subs_score)
  end
end
