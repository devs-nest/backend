# frozen_string_literal: true

module Api
  module V1
    module Admin
      # allows challenges api calls to challenge resources
      class ChallengeController < ApplicationController
        include JSONAPI::ActsAsResourceController
        before_action :problem_setter_auth

        def context
          {
            user: @current_user
          }
        end

        def add_testcase
          input_file = params['input_file'].tempfile
          output_file = params['output_file'].tempfile
          is_sample = params['is_sample'] == 'true' || params['is_sample'] == true

          challenge = Challenge.find(params[:id])
          return render_not_found if challenge.nil?

          input_path, output_path = challenge.put_testcase_in_s3(input_file, output_file)
          Testcase.create(challenge_id: challenge.id, is_sample: is_sample, input_path: input_path, output_path: output_path)
          render_success({ success: true, message: 'Testcase created successfully' })
        end

        def update_testcase
          input_file = params['input_file'].tempfile
          output_file = params['output_file'].tempfile
          is_sample = params['is_sample'] == 'true' || params['is_sample'] == true

          challenge = Challenge.find(params[:id])
          return render_not_found if challenge.nil?

          input_path, output_path = challenge.put_testcase_in_s3(input_file, output_file)
          testcase = Testcase.find(params[:testcase_id])
          render_not_found if testcase.nil?

          testcase.update(challenge_id: challenge.id, is_sample: is_sample, input_path: input_path, output_path: output_path)
          render_success({ success: true, message: 'Testcase updated successfully' })
        end

        def delete_testcase
          testcase = Testcase.find(params[:testcase_id])
          render_not_found if testcase.nil?

          testcase.destroy
          render_success({ success: true, message: 'Testcase deleted successfully' })
        end

        def testcases
          challenge = Challenge.find(params[:id])
          return render_not_found if challenge.nil?

          render_success({ id: params[:id], type: 'testcases', testcases: challenge.testcases })
        end
      end
    end
  end
end
