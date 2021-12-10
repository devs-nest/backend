# frozen_string_literal: true

module LeaderboardDevsnest
  # Initialize leaderboard with redis
  class Initializer
    RedisConnection = { redis_connection: Redis.new(url: ENV['REDIS_HOST_LB'], password: ENV['REDIS_PASSWORD_LB'], db: ENV['REDIS_DB_LB']) }
    LB = Leaderboard.new("dn_leaderboard", Devsnest::Application::REDIS_OPTIONS, RedisConnection)
  end
end
