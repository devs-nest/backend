# frozen_string_literal: true

class UserScoreUpdate
  include Sidekiq::Worker

  def perform(id, type)
    case type
    when 'dsa'
      ch = Challenge.find_by(id: id)
      submissions = UserChallengeScore.where(challenge_id: ch.id)
      submissions.each(&:touch)
    when 'frontend'
      ch = FrontendChallenge.find_by(id: id)
      submissions = FrontendChallengeScore.where(frontend_challenge_id: ch.id)
      submissions.each(&:touch)
    end
  end
end
