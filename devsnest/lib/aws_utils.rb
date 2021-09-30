# frozen_string_literal: true

# utility functions for aws
module AwsUtils
  def self.upload_file_s3(file, key, type)
    $s3.put_object(bucket: "devsnest-#{type}", key: key, body: file)
  end
end
