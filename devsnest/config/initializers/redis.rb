# frozen_string_literal: true

Redis.current = Redis.new(url: 'redis://redis:6379/0', password: ENV['REDIS_PASS'])
