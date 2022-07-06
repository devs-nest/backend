class UserScoreUpdate
  include Sidekiq::Worker

  def perform(values)
    previous_score, new_score, challenge_id = values
    challenge = Challenge.find_by(id: challenge_id)
    submissions = UserChallengeScore.where(challenge_id: challenge_id)

    submissions.each do |submission|
      user = User.find_by(id: submission.user_id)
      previous_user_score = user.score
      diff_previous_score = previous_user_score - (previous_score * (submission.passed_test_cases.to_f / submission.total_test_cases))
      add_new_score = diff_previous_score + (new_score * (submission.passed_test_cases.to_f / submission.total_test_cases))
      user.update_attribute(:score, add_new_score)
    end
    regenerate_main_leaderboard
  end

  def regenerate_main_leaderboard
    @leaderboard ||= LeaderboardDevsnest::Initializer::LB
    User.initialize_leaderboard(@leaderboard)
  end
end
