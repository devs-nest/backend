# frozen_string_literal: true

module Api
  module V1
    module Admin
      # controller to add challenges to a company
      class CompanyController < ApplicationController
        include JSONAPI::ActsAsResourceController
        before_action :admin_auth

        def create
          file = params['image-file']
          company_name = params['name']
          content_length = request.headers['content-length'].to_i
          ideal_image_size = content_length.present? ? validate_image_size(content_length) : true
          return render_error('File size too large') unless ideal_image_size

          key = "#{company_name.parameterize}.png"
          $s3&.put_object(bucket: "#{ENV['S3_PREFIX']}company-image", key: key, body: file)
          image_link = "https://#{ENV['S3_PREFIX']}company-image.s3.amazonaws.com/#{key}"
          return render_error('Company with this name already exists') if Company.find_by(name: company_name).present?

          company = Company.create!(name: company_name, image_url: image_link)
          render_success(id: company.id, message: 'Company added successfully')
        end

        def update
          file = params['image-file']
          company_id = params[:id]
          company_name = params['name']
          content_length = request.headers['content-length'].to_i
          ideal_image_size = content_length.present? ? validate_image_size(content_length) : true
          return render_error('File size too large') unless ideal_image_size

          key = "#{company_name.parameterize}.png"
          $s3&.put_object(bucket: "#{ENV['S3_PREFIX']}company-image", key: key, body: file)
          image_link = "https://#{ENV['S3_PREFIX']}company-image.s3.amazonaws.com/#{key}"
          company = Company.find(company_id)
          return render_error('Company with this name already exists') if company.name != company_name && Company.find_by(name: company_name).present?

          company.update!(name: company_name, image_url: image_link)
          render_success(id: company_id, message: 'Company updated successfully')
        end

        def validate_image_size(size)
          size.between?(60, 1_048_576)
        end
      end
    end
  end
end
