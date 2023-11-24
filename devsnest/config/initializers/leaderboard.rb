# frozen_string_literal: true

require 'competition_ranking_leaderboard'
module LeaderboardDevsnest
  # Initialize leaderboard with redis

  COURSE_TYPE = {
    'DSA': 'dsa',
    'FRONTEND': 'frontend',
    'BACKEND': 'backend'
  }.freeze

  COURSE_TIMELINE = {
    'WEEKLY': 'weekly',
    'MONTHLY': 'monthly'
  }.freeze

  REDIS_CONNECTION = {
    redis_connection: Redis.new(url: 'redis://redis:6379/0',
                                db: ENV['REDIS_DB_LB'],
                                timeout: 3600)
  }.freeze

  class DSAInitializer
    RedisConnection = { redis_connection: Redis.new(url: 'redis://redis:6379/0', db: ENV['REDIS_DB_LB'], timeout: 3600) }
    LB = CompetitionRankingLeaderboard.new('dn_leaderboard', Devsnest::Application::REDIS_OPTIONS, RedisConnection)
  end

  class FEInitializer
    RedisConnection = { redis_connection: Redis.new(url: 'redis://redis:6379/0', db: ENV['REDIS_DB_LB'], timeout: 3600) }
    LB = CompetitionRankingLeaderboard.new('fe_leaderboard', Devsnest::Application::REDIS_OPTIONS, RedisConnection)
  end

  class BEInitializer
    RedisConnection = { redis_connection: Redis.new(url: 'redis://redis:6379/0', db: ENV['REDIS_DB_LB'], timeout: 3600) }
    LB = CompetitionRankingLeaderboard.new('be_leaderboard', Devsnest::Application::REDIS_OPTIONS, RedisConnection)
  end

  class CopyLeaderboard
    def initialize(type, timeline)
      @name = "#{type}_#{timeline}_leaderboard_copy"
    end

    def call
      redis = { redis_connection: Redis.new(url: 'redis://redis:6379/0', db: ENV['REDIS_DB_LB'], timeout: 1800) }
      CompetitionRankingLeaderboard.new(@name, Devsnest::Application::REDIS_OPTIONS, redis)
    end
  end

  class AlgoLeaderboard
    def initialize(name)
      @name = name
    end

    def call
      redis = { redis_connection: Redis.new(url: 'redis://redis:6379/0', db: ENV['REDIS_DB_LB'], timeout: 1800) }
      CompetitionRankingLeaderboard.new(@name, Devsnest::Application::REDIS_OPTIONS, redis)
    end
  end

  class FeLeaderboard
    def initialize(name)
      @name = "#{name}_fe"
    end

    def call
      redis = { redis_connection: Redis.new(url: 'redis://redis:6379/0', db: ENV['REDIS_DB_LB'], timeout: 1800) }
      CompetitionRankingLeaderboard.new(@name, Devsnest::Application::REDIS_OPTIONS, redis)
    end
  end

  class BeLeaderboard
    def initialize(name)
      @name = "#{name}_be"
    end

    def call
      redis = { redis_connection: Redis.new(url: 'redis://redis:6379/0', db: ENV['REDIS_DB_LB'], timeout: 1800) }
      CompetitionRankingLeaderboard.new(@name, Devsnest::Application::REDIS_OPTIONS, redis)
    end
  end

  class RoomLeaderboard
    def initialize(room_id)
      @name = "room_#{room_id}"
    end

    def call
      redis = { redis_connection: Redis.new(url: 'redis://redis:6379/0', db: ENV['REDIS_DB_LB'], timeout: 1800) }
      CompetitionRankingLeaderboard.new(@name, Devsnest::Application::REDIS_OPTIONS, redis)
    end
  end
end
