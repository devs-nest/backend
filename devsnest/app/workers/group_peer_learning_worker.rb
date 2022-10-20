# frozen_string_literal: true

# worker to update group activity points every week
class GroupPeerLearningWorker
  include Sidekiq::Worker
  def perform(worker_type)
    Group.all.each do |group|
      case worker_type
      when 'weekly'
        ping(group, 'Report_Weekly_Scrum')
      when 'daily'
        ping(group, 'Ping_Attendance')
        ping(group, 'Report_Daily_Scrum_Detailse')
      when 'class_start'
        ping(group, 'Class_Start')
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
