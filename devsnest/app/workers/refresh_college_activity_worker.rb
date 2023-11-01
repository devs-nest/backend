# frozen_string_literal: true

# Refresh activity of all colleges in redis
class RefreshCollegeActivityWorker
  include Sidekiq::Worker

  def perform
    College.all.map(&:activity)
  end
end
