# frozen_string_literal: true

# worker to update dsa and frontend leaderboard every week
class CopyLeaderboardWorker
  include Sidekiq::Worker

  def perform(args)
    course_timeline = args['timeline']

    LeaderboardDevsnest::COURSE_TYPE.each_value do |course_type|
      lb = course_type == 'dsa' ? LeaderboardDevsnest::DSAInitializer::LB : LeaderboardDevsnest::FEInitializer::LB
      lb_copy = LeaderboardDevsnest::CopyLeaderboard.new(course_type, course_timeline).call

      (1..lb.total_pages).each do |n|
        lb.leaders(n).each do |data|
          lb_copy.rank_member(data[:name], data[:score])
        end
      end
    end
  end
end
