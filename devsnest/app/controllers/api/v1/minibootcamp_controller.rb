# frozen_string_literal: true

module Api
  module V1
    # Minibootcamp Cotroller
    class MinibootcampController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :create_submission, only: %i[create update]

      def context
        {
          parent_id: params.dig('filter', 'parent_id')
        }
      end

      def create_submission
        module_id = params.dig(:data, :attributes, :module_id)
        file_name = params.dig(:data, :attributes, :file_name)
        raw_code = params.dig(:data, :attributes, :raw_code)
        bucket = "#{ENV['S3_PREFIX']}-minibootcamp"
        key = "#{1}/#{module_id}/#{file_name}.txt"

        # move to model
        $s3.put_object(bucket: bucket, key: key, body: raw_code)
      end
    end
  end
end
