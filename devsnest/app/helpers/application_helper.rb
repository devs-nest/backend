# frozen_string_literal: true

module ApplicationHelper
  def put_test_cases(bucket, file, key)
    $s3&.put_object(bucket: "#{ENV['S3_PREFIX']}#{bucket}", key: key, body: file)
  end

  def remove_test_cases(bucket, key)
    $s3&.delete_object(bucket: "#{ENV['S3_PREFIX']}#{bucket}", key: key)
  end

  def io_boilerplate(files, base_path, bucket, action = 'add')
    files.each do |file|
      key = "#{base_path}#{file[0]}"

      begin
        if action == 'add'
          put_test_cases(bucket, file[1], key)
        else
          remove_test_cases(bucket, key)
        end
      rescue StandardError => e
        return render_error(message: e.message)
      end
    end
  end

  def valid_phone_number?(phone_number)
    /^\d{10}$/.match?(phone_number)
  end

  def remaining_time_label(remaining_time)
    if remaining_time >= 60
      "#{remaining_time/60} minutes"
    else
      "#{remaining_time} seconds"
    end
  end

  def send_otp_service(phone_number, otp)
    response = HTTParty.post('https://www.fast2sms.com/dev/bulkV2', headers: {
      authorization: ENV['OTP_SERVICE_API_KEY']
      }, body: {
      route: 'otp',
      variables_values: otp,
      numbers: phone_number
    })
    [response.code, JSON.parse(response.body)]
  end
end
