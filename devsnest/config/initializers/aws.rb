# frozen_string_literal: true

$sqs =
  (Aws::SQS::Client.new if ENV['AWS_REGION'].present? && ENV['AWS_ACCESS_KEY_ID'].present? && ENV['AWS_SECRET_ACCESS_KEY'].present?)

$s3 =
  (Aws::S3::Client.new if ENV['AWS_REGION'].present? && ENV['AWS_ACCESS_KEY_ID'].present? && ENV['AWS_SECRET_ACCESS_KEY'].present?)
