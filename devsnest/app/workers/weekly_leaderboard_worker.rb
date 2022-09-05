class WeeklyLeaderboardWorker
  include Sidekiq::Worker

  def perform
    daily_lb = LeaderboardDevsnest::Initializer::LB
    weekly_lb = LeaderboardDevsnest::WeeklyLeaderboard::WLB
    User.initialize_weekly_dsa_leaderboard(daily_lb, weekly_lb)
  end
end