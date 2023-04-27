# frozen_string_literal: true

# Helper for Minibootcamp
module MinibootcampHelper
  def s3_files_to_json(bucket, prefix)
    files = {}
    s3_files = $s3_resource&.bucket(bucket)&.objects(prefix: prefix)&.collect(&:key) || []
    s3_files.each do |file|
      next unless file.end_with?('.txt')

      content = $s3&.get_object(bucket: bucket, key: file)&.body&.read
      file_name = file.sub(prefix, '').sub('.txt', '')

      files.merge!(Hash[file_name, content])
    end

    files
  end
end
