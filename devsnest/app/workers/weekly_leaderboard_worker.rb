class WeeklyLeaderboardWorker
  include Sidekiq::Worker

  def perform
    daily_lb = LeaderboardDevsnest::Initializer::LB
    weekly_lb = LeaderboardDevsnest::WeeklyLeaderboard::WLB

    daily_lb.all_leaders.each do |lb_data|
      weekly_lb.rank_member(lb_data['name'.to_sym], lb_data['score'.to_sym])
    end
  end
end