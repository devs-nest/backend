# frozen_string_literal: true

require 'competition_ranking_leaderboard'
require 'tie_ranking_leaderboard'
module LeaderboardDevsnest
  # Initialize leaderboard with redis

  # class Initializer
  #   RedisConnection = { redis_connection: Redis.new(url: ENV['REDIS_HOST_LB'], password: ENV['REDIS_PASSWORD_LB'], db: ENV['REDIS_DB_LB']) }
  #   LB = Leaderboard.new('dn_leaderboard', Devsnest::Application::REDIS_OPTIONS, RedisConnection)
  # end

  class LB
    def initialize(type, timeline)
      @name = "#{type}_#{timeline}_leaderboard"
    end
    def call
      redis = { redis_connection: Redis.new(url: ENV['REDIS_HOST_LB'], password: ENV['REDIS_PASSWORD_LB'], db: ENV['REDIS_DB_LB'], timeout: 1800) }
      TieRankingLeaderboard.new(@name, Devsnest::Application::REDIS_OPTIONS, redis)
    end
  end

  class AlgoLeaderboard
    def initialize(name)
      @name = name
    end

    def call
      redis = { redis_connection: Redis.new(url: ENV['REDIS_HOST_LB'], password: ENV['REDIS_PASSWORD_LB'], db: ENV['REDIS_DB_LB'], timeout: 1800) }
      CompetitionRankingLeaderboard.new(@name, Devsnest::Application::REDIS_OPTIONS, redis)
    end
  end
end
