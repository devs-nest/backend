class WeeklyLeaderboardWorker
  include Sidekiq::Worker

  def perform
    ['dsa', 'frontend'].each do |course_type|
      p course_type
      daily_lb = LeaderboardDevsnest::LB.new(course_type, 'daily').call
      weekly_lb = LeaderboardDevsnest::LB.new(course_type, 'weekly').call
      prev_week_leaders = {}

      weekly_lb.all_leaders.each do |data|
        prev_week_leaders[data[:name]] = [data[:rank], data[:score]]
      end
      # shallow copy deletes the prev_week_leaders as well
      # weekly_lb.delete_leaderboard

      daily_lb.all_leaders.each do |data|
        rank_change = prev_week_leaders.key?(data[:name]) ? prev_week_leaders[data[:name]][0] - data[:rank] : 0
        weekly_lb.rank_member(data[:name], data[:score], {'rank_change' => rank_change}.to_json)
      end
    end
  end
end
