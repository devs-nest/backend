# frozen_string_literal: true

namespace :regenerate_ch_leaderboards do
  desc 'Re gen challenge leader board'
  task data: :environment do
    challenges = Challenge.all

    challenges.each do |challenge|
      ch_lb = LeaderboardDevsnest::AlgoLeaderboard.new("#{challenge.slug}-lb").call
      
      ch_lb.delete_leaderboard
      ch_lb_new = LeaderboardDevsnest::AlgoLeaderboard.new("#{challenge.slug}-lb").call

      best_submissions = challenge.algo_submissions.where(is_best_submission: true)
      best_submissions.each do |submission|
        user = User.find(submission.user_id)

        ch_lb_new.rank_member("#{user.username}", challenge.score * (submission.passed_test_cases.to_f / submission.total_test_cases))
      end
    end
  end
end
