# frozen_string_literal: true

# worker to update dsa and frontend leaderboard every week
class CopyLeaderboardWorker
  include Sidekiq::Worker

  def perform
    course_timeline = Sidekiq::Cron::Job.find('copy_leaderboard_job').args[0]['timeline']

    LeaderboardDevsnest::COURSE_TYPE.values.each do |course_type|
      dsa_lb = LeaderboardDevsnest::DSAInitializer::LB
      lb_copy = LeaderboardDevsnest::CopyLeaderboard.new(course_type, course_timeline).call

      dsa_lb.all_leaders.each do |data|
        lb_copy.rank_member(data[:name], data[:score])
      end
    end
  end
end
