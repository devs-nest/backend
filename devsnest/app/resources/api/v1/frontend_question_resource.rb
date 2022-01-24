# frozen_string_literal: true

module Api
  module V1
    # resource for frontend questions (minibootcamp)
    class FrontendQuestionResource < JSONAPI::Resource
      attributes :name, :question_markdown, :template, :active_path, :open_paths, :protected_paths, :hidden_files, :show_explorer
      attributes :template_files, :last_submitted_files, :is_solved, :submission_id

      def template_files
        @model.template_files
      end

      def last_submitted_files
        files = {}
        bucket = "#{ENV['S3_PREFIX']}minibootcamp"
        prefix = "submissions/#{@model.id}/#{context[:user].id}/"
        s3_files = $s3_resource.bucket(bucket).objects(prefix: prefix).collect(&:key)
        s3_files.each do |file|
          next unless file.end_with?(".txt")
          
          content = $s3.get_object(bucket: bucket, key: file).body.read
          file.slice! prefix
          file.slice! ".txt"
          
          files.merge!(Hash[file, content])
        end

        files
      end

      def is_solved
        @model.minibootcamp_submissions.find_by(user_id: context[:user].id)&.is_solved
      end

      def submission_id
        @model.minibootcamp_submissions.find_by(user_id: context[:user].id)&.id
      end
    end
  end
end
