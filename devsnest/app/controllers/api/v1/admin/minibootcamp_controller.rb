# frozen_string_literal: true

module Api
  module V1
    module Admin
      # Minibootcamp Controller
      class MinibootcampController < ApplicationController
        include JSONAPI::ActsAsResourceController
        before_action :admin_auth

        def upload_custom_image
          return render_error("Image missing") unless params[:custom_image].present?
          bucket = "#{ENV['S3_PREFIX']}custom-images"
          key = params[:image_name]
 
          begin
            existing_object = $s3.get_object(bucket: bucket, key: key)
            return render_error("Image with same name already exists") if params[:force_upload].nil?
          rescue Exception
          ensure
            $s3.put_object(bucket: bucket, key: key, body: params[:custom_image])
          end   
        end
        
        def fetch_custom_image
          prefix = params[:search] || ''
          bucket = "#{ENV['S3_PREFIX']}custom-images"
          s3_files = $s3_resource.bucket(bucket).objects(prefix: prefix).collect(&:key)
          public_urls = s3_files.map {|e| "https://#{ENV['S3_PREFIX']}custom-images.s3.ap-south-1.amazonaws.com/#{e}"}
          api_render(200, { id: 1, type: 'custom_images', public_urls: public_urls })
        end
      end
    end
  end
end
