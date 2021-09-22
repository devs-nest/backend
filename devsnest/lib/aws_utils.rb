module AwsUtils
  def self.upload_file_s3(file, key, type)
    $s3.put_object(bucket: "devsn-#{type}", key: key, body: file)
  end
end