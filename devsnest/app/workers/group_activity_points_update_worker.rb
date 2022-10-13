# frozen_string_literal: true

# worker to update group activity points every week
class GroupActivityPointsUpdateWorker
  include Sidekiq::Worker
  def perform
    Group.all.each do |group|
      group.update(activity_point: group.count_activity_point)
    end
  end
end
