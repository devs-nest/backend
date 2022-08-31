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
end
