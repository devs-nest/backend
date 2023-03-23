# frozen_string_literal: true

module Api
  module V1
    module Admin
      # Minibootcamp Controller
      class MinibootcampController < ApplicationController
        include JSONAPI::ActsAsResourceController
        before_action :problem_setter_auth

        def upload_custom_image
          return render_error('Image missing') unless params[:custom_image].present?

          bucket = "#{ENV['S3_PREFIX']}custom-images"
          key = params[:image_name]

          begin
            existing_object = $s3.get_object(bucket: bucket, key: key)
            return render_error('Image with same name already exists') if params[:force_upload].nil?
          rescue Exception
          ensure
            $s3.put_object(bucket: bucket, key: key, body: params[:custom_image])
          end
        end

        def fetch_custom_image
          prefix = params[:search] || ''
          bucket = "#{ENV['S3_PREFIX']}custom-images"
          marker = params[:marker] || ''

          list_objects = $s3.list_objects(bucket: bucket, prefix: prefix, max_keys: 20, marker: marker)
          public_urls = []
          list_objects[:contents].each do |response|
            public_urls << "https://#{ENV['S3_PREFIX']}custom-images.s3.ap-south-1.amazonaws.com/#{response[:key]}"
          end

          api_render(200, { id: 1,
                            type: 'custom_images',
                            public_urls: public_urls,
                            next_marker: list_objects[:contents].empty? ? '' : list_objects[:contents].last.key,
                            next_page: list_objects.next_page? })
        end
      end
    end
  end
end
