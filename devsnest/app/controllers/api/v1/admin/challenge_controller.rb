# frozen_string_literal: true

module Api
  module V1
    module Admin
      # allows challenges api calls to challenge resources
      class ChallengeController < ApplicationController
        include JSONAPI::ActsAsResourceController
        before_action :problem_setter_auth
        before_action :admin_auth, only: %i[index]

        def context
          {
            user: @current_user
          }
        end

        def self_created_challenges
          render_success({ id: @current_user.id, type: 'challenges', challenges: @current_user.challenges })
        end

        def add_testcase
          input_file = params['input_file']&.tempfile || 'Hello World'
          output_file = params['output_file']&.tempfile || 'Hello World'
          is_sample = params['is_sample'] == 'true' || params['is_sample'] == true

          challenge = Challenge.find(params[:id])
          return render_not_found if challenge.nil?

          input_filename, output_filename = challenge.put_testcase_in_s3(input_file, output_file, nil)
          Testcase.create(challenge_id: challenge.id, is_sample: is_sample, input_path: input_filename, output_path: output_filename)
          render_success({ success: true, message: 'Testcase created successfully' })
        end

        def update_testcase
          input_file = params['input_file']&.tempfile || 'Hello World'
          output_file = params['output_file']&.tempfile || 'Hello World'
          is_sample = params['is_sample'] == 'true' || params['is_sample'] == true

          challenge = Challenge.find(params[:id])
          return render_not_found if challenge.nil?

          testcase = Testcase.find(params[:testcase_id])
          render_not_found if testcase.nil?
          input_filename, output_filename = challenge.put_testcase_in_s3(input_file, output_file, testcase)

          testcase.update(challenge_id: challenge.id, is_sample: is_sample, input_path: input_filename, output_path: output_filename)
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

        def update_company_tags
          challenge = Challenge.find(params[:id])
          return render_not_found if challenge.nil?

          already_existing_companies_names = challenge.companies.pluck(:name)
          companies_to_be_added = params[:data][:attributes][:companies]
          companies_to_be_deleted = already_existing_companies_names - companies_to_be_added
          companies_to_be_added -= already_existing_companies_names

          challenge.add_companies(companies_to_be_added)
          challenge.delete_companies(companies_to_be_deleted)

          render_success({ id: challenge.id, type: 'challenges', message: 'Company Tags Updated Successfully' })
        end

        def active_questions
          challenges = Challenge.where(is_active: true).select('id', 'name', 'slug')
          render_success({ type: 'challenges', challenges: challenges })
        end
      end
    end
  end
end
