# frozen_string_literal: true

class UserScoreUpdate
  include Sidekiq::Worker

  def perform(id)
    ch = Challenge.find_by(id: id)
    submissions = UserChallengeScore.where(challenge_id: ch.id)
    submissions.each do |submission|
      submission.touch
    end
  end
end
