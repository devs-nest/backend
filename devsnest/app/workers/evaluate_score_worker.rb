# frozen_string_literal: true

# Evaluate Score Worker
class EvaluateScoreWorker
  include Sidekiq::Worker

  def perform(user_id, type)
    case type
    when 'dsa'
      challenge_ids = Challenge.where(is_active: true)
      user = User.find_by(id: user_id)
      all_user_subs_score = UserChallengeScore.where(user: user_id, challenge_id: challenge_ids).sum { |ucs| ucs.score || 0 }
      user.update(score: all_user_subs_score)
    when 'frontend'
      challenge_ids = FrontendChallenge.where(is_active: true)
      user = User.find_by(id: user_id)
      all_user_subs_score = FrontendChallengeScore.where(user: user_id, frontend_challenge_id: challenge_ids).sum { |fcs| fcs.score || 0 }
      user.update(fe_score: all_user_subs_score)
    when 'backend'
      challenge_ids = BackendChallenge.where(is_active: true)
      user = User.find_by(id: user_id)
      all_user_subs_score = BackendChallengeScore.where(user: user_id, backend_challenge_id: challenge_ids).sum { |bcs| bcs.score || 0 }
      user.update(be_score: all_user_subs_score)
    end
  end
end
