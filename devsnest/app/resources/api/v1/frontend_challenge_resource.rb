# frozen_string_literal: true

module Api
  module V1
    # api for challenge test controller
    class FrontendChallengeResource < JSONAPI::Resource
      attributes :topic, :difficulty, :name, :question_body, :score, :slug, :hidden_files, :protected_paths, :open_paths, :template, :active_path, :challenge_type, :testcases_path, :active_path,
                 :day_no, :is_active, :user_id, :course_curriculum_id
      attributes :submission_status
      filter :difficulty
      filter :topic
      filter :is_active
      attributes :files

      def files
        data = []
        files = $s3.list_objects(bucket: "#{ENV['S3_PREFIX']}frontend-testcases", prefix: "#{id}/")
        files.contents.each do |file|
          next if self.challenge_type == 'github' && file.key.to_s.include?('test')

          data << { 'path' => file.key.to_s, 'content' => $s3.get_object(bucket: "#{ENV['S3_PREFIX']}frontend-testcases", key: file.key).body.read.to_s }
        end
        data.as_json
      end

      def submission_status
        user = context[:user]
        return 'signin to check submissions' if user.nil?

        submission = user.frontend_challenge_score.find_by(frontend_challenge_id: @model.id)
        return 'unsolved' if submission.blank?

        submission.passed_test_cases == submission.total_test_cases ? 'solved' : 'attempted'
      end
    end
  end
end
