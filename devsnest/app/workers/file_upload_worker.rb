# frozen_string_literal: true

class FileUploadWorker
  include Sidekiq::Worker

  def perform(type, range, file_record_id)
    s = Time.parse(range[0]).to_date
    e = Time.parse(range[1]).to_date
    delta = s..e
    file_record = FileUploadRecord.find_by(id: file_record_id)

    case type
    when 'user_details'
      url, file_name = JtdHelper.jtd_user_progress(delta, "#{s.to_date}-#{e.to_date}")
    when 'scrum_details'
      url, file_name = JtdHelper.jtd_scrum_details(delta, "#{s.to_date}-#{e.to_date}")
    when 'batch_leader_details'
      url, file_name = JtdHelper.batch_leader_details(delta, "#{s.to_date}-#{e.to_date}")
    end
    file_record.update(file: url, status: 1, filename: file_name, start_date: s, end_date: e)
  end
end
