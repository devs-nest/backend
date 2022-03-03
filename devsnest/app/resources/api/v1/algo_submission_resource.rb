# frozen_string_literal: true

module Api
  module V1
    # api for testing the population submissions
    class AlgoSubmissionResource < JSONAPI::Resource
      attributes :user_id, :challenge_id, :source_code, :language, :test_cases, :total_test_cases, :passed_test_cases, :is_submitted, :status, :total_runtime, :total_memory
      attributes :score_achieved, :next_question

      def next_question
        return nil if @model.status != "Accepted"
        topic = @model.challenge.topic
        topic_challenge_ids = Challenge.where(topic: topic).pluck(:id)

        user_success_submissions_for_topic = AlgoSubmission.where(challenge_id: topic_challenge_ids, is_best_submission: true, user_id: context[:user].id, status: "Accepted")
        relevent_unsolved_submissions = topic_challenge_ids - user_success_submissions_for_topic.pluck(:challenge_id)
        byebug
        
        if relevent_unsolved_submissions.empty?
          all_submitted_challenges = AlgoSubmission.where(is_best_submission: true, user_id: context[:user].id, status: "Accepted").pluck(:challenge_id)
          relevent_unsolved_submissions = Challenge.all.pluck(:id) - all_submitted_challenges
        end

        return nil if relevent_unsolved_submissions.empty?
        Challenge.find(relevent_unsolved_submissions[0]).slug
      end

      def score_achieved
        testcases_count = @model.challenge.testcases.count
        return 0 if testcases_count.zero?

        (@model.passed_test_cases / testcases_count.to_f) * @model.challenge.score
      end
    end
  end
end
