# frozen_string_literal: true

module Api
  module V1
    module Admin
      # api for challenge test controller
      class ChallengeResource < JSONAPI::Resource
        attributes :topic, :difficulty, :name, :question_body, :score, :priority, :tester_code, :slug, :created_by
        filter :difficulty
        filter :topic
      end
    end
  end
end
