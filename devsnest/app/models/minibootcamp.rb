# frozen_string_literal: true

# Minibootcamp resourses
class Minibootcamp < ApplicationRecord
  enum content_type: %i[topic subtopic module]
  has_one :frontend_question

  # def self.create_submission(key, path)
  #   $s3.put_object(bucket: ENV['S3_PREFIX'] + path, key: key)
  # end

  

  # def upload_files
  #   return unless params['file_upload'].present? && (params['file_upload_type'] == 'profile-image' || params['file_upload_type'] == 'resume')

  #   type = params['file_upload_type']
  #   file = params['file_upload']
  #   mime = User.mime_types_s3(type)
  #   threshold_size = type == 'profile-image' ? 4_194_304 : 5_242_880
  #   return render_error('Unsupported format') unless mime.include? file.content_type
  #   return render_error('File size too large') if request.headers['content-length'].to_i > threshold_size

  #   key = "#{@current_user.id}/#{SecureRandom.hex(8)}_#{type}"
  #   User.upload_file_s3(file, key, type)
  #   update_link = type == 'profile-image' ? 'image_url' : 'resume_url'

  #   bucket = "https://#{ENV["S3_PREFIX"]}#{type}.s3.amazonaws.com/"

  #   public_link = bucket + key
  #   @current_user.update("#{update_link}": public_link)

  #   api_render(200, { id: key, type: type, user_id: @current_user.id, bucket: "devsnest-#{type}", public_link: public_link })
  # end
  # def get_files_from_s3_with_prefix(path, prefix)
  #   $s3.list_objects(bucket: "#{ENV['S3_PREFIX']}minibootcamp/#{id}/#{path}").contents.select { |file| file.key.include?(prefix) }.map(&:key)
  # end

  # def put_file_in_s3(path, file)
  #   $s3.put_object(bucket: "#{ENV['S3_PREFIX']}minibootcamp/#{id}/#{path}", key: path, body: file)
  # end

  # def put_files_in_s3_with_prefix(path, prefix, files)
  #   files.each do |file|
  #     $s3.put_object(bucket: "#{ENV['S3_PREFIX']}minibootcamp/#{id}/#{path}", key: "#{prefix}/#{file}", body: File.open("#{path}/#{file}"))
  #   end
  # end
end
