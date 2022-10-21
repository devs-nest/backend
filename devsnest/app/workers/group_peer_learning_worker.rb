# frozen_string_literal: true

# worker to update group activity points every week
class GroupPeerLearningWorker
  include Sidekiq::Worker
  def perform(worker_type)
    Group.all.each do |group|
      case worker_type
      when 'weekly'
        ping_discord(group, 'Report_Weekly_Scrum')
      when 'daily'
        ping_discord(group, 'Ping_Attendance')
      when 'class_start'
        ping_discord(group, 'Class_Start')
      when 'scrum_start'
        if group.scrum_start_time
          scrum_time = group.scrum_start_time.change(year: DateTime.now.year, month: DateTime.now.month, day: DateTime.now.day)
          start_interval = Time.now
          end_interval = (Time.now + 30.minute)
          ping_discord(group, 'Ping_Scrum_Time', [scrum_time.strftime('%M').to_i - start_interval.strftime('%M').to_i]) if scrum_time >= start_interval && scrum_time < end_interval
        end
      end
    end
  end
end
