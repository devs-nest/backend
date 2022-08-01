# frozen_string_literal: true

module Api
  module V1
    # algo submission controller
    class RunSubmissionController < ApplicationController
      include JSONAPI::ActsAsResourceController
      include AlgoHelper
      before_action :user_auth, only: %i[create show]

      def context
        { user: @current_user }
      end

      def callback
        return render_unauthorized if params[:token].nil?

        submission_id = Judgeztoken.find_by(token: params[:token]).try(:submission_id)

        return render_error('test case not found in judgezero records') if submission_id.nil?

        submission = RunSubmission.find_by_id(submission_id)

        return render_error('test case not found in submission') if submission.test_cases.key?(params[:token]).blank?

        return render_success if submission.test_cases.dig(params[:token], 'status_description').present?

        submission.with_lock do
          res_hash = prepare_test_case_result(params)
          submission.status = res_hash['status_description'] if order_status(submission.status) <= order_status(res_hash['status_description'])
          submission.total_runtime = submission.total_runtime.to_f + res_hash['time'].to_f
          submission.total_memory = submission.total_memory.to_i + res_hash['memory'].to_i
          submission.test_cases[params[:token]] = submission.test_cases[params[:token]].merge(res_hash)
          submission.passed_test_cases = passed_test_cases_count(submission)
          submission.status = 'Pending' if submission.status == 'Accepted' && submission.total_test_cases > submission.passed_test_cases
          # submission.is_best_submission = mark_current_as_best_submission
          submission.save!
        end
      end
    end
  end
end
