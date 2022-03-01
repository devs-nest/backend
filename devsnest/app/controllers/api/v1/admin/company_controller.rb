# frozen_string_literal: true

module Api
  module V1
    module Admin
      # controller to add challenges to a company
      class CompanyController < ApplicationController
        include JSONAPI::ActsAsResourceController
        before_action :admin_auth

        def add_company
          file = params['image-file']
          company_name = params[:name]
          ideal_image_size = max_image_size(request.headers['content-length'].to_i)
          return render_error('File size too large') unless ideal_image_size

          key = "#{company_name.parameterize}.png"
          $s3&.put_object(bucket: "#{ENV['S3_PREFIX']}company-image", key: key, body: file)
          image_link = "https://#{ENV['S3_PREFIX']}company-image.s3.amazonaws.com/#{key}"
          Company.create(name: company_name, image_url: image_link)
        end

        def update_company
          file = params['image-file']
          company_id = params[:id]
          company_name = params[:name]
          ideal_image_size = max_image_size(request.headers['content-length'].to_i)
          return render_error('File size too large') unless ideal_image_size

          key = "#{company_name.parameterize}.png"
          $s3&.put_object(bucket: "#{ENV['S3_PREFIX']}company-image", key: key, body: file)
          image_link = "https://#{ENV['S3_PREFIX']}company-image.s3.amazonaws.com/#{key}"
          Company.find(company_id).update(name: company_name, image_url: image_link)
        end

        def max_image_size(size)
          100 < size && size < 1_048_576
        end
      end
    end
  end
end
