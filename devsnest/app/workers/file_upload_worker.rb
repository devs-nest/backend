# frozen_string_literal: true

class FileUploadWorker
  include Sidekiq::Worker

  def perform(type, range, file_record_id)
    delta = Time.parse(range[0]).beginning_of_day..Time.parse(range[1]).end_of_day
    file_record = FileUploadRecord.find_by(id: file_record_id)

    case type
    when 'user_details'
      url = JtdHelper.jtd_user_progress(delta)
      file_record.update(file: url, status: 1)
    when 'scrum_details'
      url = JtdHelper.jtd_scrum_details(delta)
      file_record.update(file: url, status: 1)
    end
  end
end
