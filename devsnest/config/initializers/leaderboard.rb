# frozen_string_literal: true

module LeaderboardDevsnest
  # Initialize leaderboard with redis
  class Initializer
    RedisConnection = { redis_connection: Redis.new }
    LB = Leaderboard.new(ENV['REDIS_DB'], Devsnest::Application::REDIS_OPTIONS, RedisConnection)
  end
end
