# frozen_string_literal: true

module Api
  module V1
    # algo submission controller
    class AlgoSubmissionController < ApplicationController
      include JSONAPI::ActsAsResourceController

      def create
        lang_id = params[:data][:attributes][:language_id].to_s
        challenge_id = params[:data][:attributes][:challenge_id].to_s
        challenge_name = Challenge.find_by(id: challenge_id).name
        source_code = params[:data][:attributes][:source_code]

        if params[:run_code] == 'true'
          is_submitted = false
          batch, total_test_cases = AlgoSubmission.run_code(params, lang_id, challenge_id, challenge_name, source_code)
        else
          is_submitted = true
          batch, total_test_cases = AlgoSubmission.submit_code(params, lang_id, challenge_id, challenge_name, source_code)
        end

        submission = AlgoSubmission.create(source_code: source_code, language_id: lang_id, challenge_id: challenge_id, test_cases: {}, is_submitted: is_submitted)
        tokens = JSON.parse(AlgoSubmission.post_to_judgez({ 'submissions' => batch }))
        puts tokens
        submission.ingest_tokens(tokens)

        submission.update(total_test_cases: total_test_cases)

        api_render(201, { submission_id: submission[:id] })
      end

      def callback
        submission_id = Judgeztoken.find_by(token: params[:token]).submission_id
        puts "running CALLBACK ......... #{submission_id}"
        submission = AlgoSubmission.find_by(id: submission_id)
        submission.with_lock do
          submission.test_cases[params[:token]] = AlgoSubmission.prepare_test_case_result(params)
          submission.passed_test_cases += 1 if params[:status][:id] == 3
          submission.save!
        end
      end
    end
  end
end
