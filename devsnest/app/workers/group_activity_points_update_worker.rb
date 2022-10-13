class GroupActivityPointsUpdateWorker
  include Sidekiq::Worker
  # worker to update group activity points every week
  def perform
    Group.all.each do |group|
      group.update(activity_point: group.count_activity_point)
    end
  end
end
