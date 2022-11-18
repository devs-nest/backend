# frozen_string_literal: true

# worker that evaluates testcases of submission
class BeEvaluationWorker
  include Sidekiq::Worker

  def perform(be_submission_id)
    be_submission = BeSubmission.find_by_id(be_submission_id)
    backend_challenge = BackendChallenge.find_by_id(be_submission.backend_challenge_id)
    test_case_report = backend_challenge.give_test_case_report(be_submission.submitted_url)
    be_submission.update!(total_test_cases: test_case_report[:total_test_cases], passed_test_cases: test_case_report[:total_passed],
                          passed_test_cases_desc: test_case_report[:passed_test_cases_desc], failed_test_cases_desc: test_case_report[:failed_test_cases_desc], status: test_case_report[:all_test_passed])
  end
end