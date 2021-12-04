# frozen_string_literal: true

module LeaderboardDevsnest
  # Initialize leaderboard with redis
  class Initializer
    RedisConnection = { redis_connection: Redis.new(url: ENV['REDIS_HOST_LB'], password: ENV['REDIS_PASSWORD_LB'], db: ENV['REDIS_DB_LB']) }
    # RedisConnection = {:host => 'redis://redis-16799.c264.ap-south-1-1.ec2.cloud.redislabs.com', :password => 'KWHz4C13IPs5sgQHYNs8YCuM7EsztXUh', :db => 'dn-prod-lb-redis', port: '16799'}

    LB = Leaderboard.new(ENV['REDIS_DB'], Devsnest::Application::REDIS_OPTIONS, RedisConnection)
  end
end
