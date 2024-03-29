# frozen_string_literal: true

module Api
  module V1
    # algo submission controller
    class AlgoSubmissionController < ApplicationController
      include JSONAPI::ActsAsResourceController
      include AlgoHelper
      before_action :user_auth, only: %i[create show]

      def context
        { user: @current_user }
      end

      def create
        lang = params[:data][:attributes][:language].to_s
        challenge_id = params[:data][:attributes][:challenge_id].to_s
        source_code = params[:data][:attributes][:source_code]
        coding_room_id = params[:data][:attributes][:coding_room_id].to_i

        if params[:run_code].present?
          record_type = 'run_submissions'
          submission = RunSubmission.create!(source_code: source_code, user_id: @current_user.id, language: lang, challenge_id: challenge_id, test_cases: {}, status: 'Pending')
          batch, total_test_cases, expected_output_batch, stdins = RunSubmission.run_code(params, lang, challenge_id, source_code, submission.id)
        else
          is_submitted = true
          record_type = 'algo_submissions'
          submission = AlgoSubmission.create(source_code: source_code, user_id: @current_user.id, language: lang, challenge_id: challenge_id, test_cases: {}, is_submitted: is_submitted,
                                             status: 'Pending', coding_room_id: coding_room_id)
          batch, total_test_cases, expected_output_batch, stdins = AlgoSubmission.submit_code(params, lang, challenge_id, source_code, submission.id)
        end

        submission.update(total_test_cases: total_test_cases)
        tokens = JSON.parse(AlgoSubmission.post_to_judgez({ 'submissions' => batch }))
        zipped_tokens = tokens.zip(expected_output_batch, stdins)
        submission.ingest_tokens(zipped_tokens, submission)

        api_render(201, { id: submission[:id], type: record_type })
      end

      def callback
        return render_unauthorized if params[:token].nil?

        submission_id = params[:submission_id]

        return render_error('test case not found in judgezero records') if submission_id.nil?

        submission = AlgoSubmission.get_by_cache(submission_id)

        return render_success if submission.test_cases.dig(params[:token], 'status_description').present?

        submission.with_lock do
          res_hash = prepare_test_case_result(params)
          submission.status = res_hash['status_description'] if order_status(submission.status) <= order_status(res_hash['status_description'])
          submission.total_runtime = submission.total_runtime.to_f + res_hash['time'].to_f
          submission.total_memory = submission.total_memory.to_i + res_hash['memory'].to_i
          submission.test_cases[params[:token]] ||= {}
          submission.test_cases[params[:token]] = submission.test_cases[params[:token]].merge(res_hash)
          submission.passed_test_cases = passed_test_cases_count(submission)
          submission.status = 'Pending' if submission.status == 'Accepted' && submission.total_test_cases > submission.passed_test_cases
          submission.save!
        end
      end
    end
  end
end
