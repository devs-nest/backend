# frozen_string_literal: true

class UserScoreUpdate
  include Sidekiq::Worker

  def perform(values)
    previous_score, new_score, challenge_id = values
    challenge = Challenge.find_by(id: challenge_id)
    submissions = UserChallengeScore.where(challenge_id: challenge_id)

    submissions.each do |submission|
      submission.update(score: challenge.score * (submission.passed_test_cases.to_f / submission.total_test_cases))
    end
    regenerate_main_leaderboard
  end

  def regenerate_main_leaderboard
    @leaderboard ||= LeaderboardDevsnest::Initializer::LB
    User.initialize_leaderboard(@leaderboard)
  end
end
