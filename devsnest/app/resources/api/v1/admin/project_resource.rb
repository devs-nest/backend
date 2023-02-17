# frozen_string_literal: true

module Api
  module V1
    module Admin
      class ProjectResource < JSONAPI::Resource
        attributes :banner, :challenge_details, :challenge_id, :challenge_type, :intro

        def challenge_details
          return { title: @model.challenge.title, slug: @model.challenge.slug } if challenge_type == 'Article'

          {
            name: @model.challenge.name,
            difficulty: @model.challenge.difficulty,
            slug: @model.challenge.slug,
            score: @model.challenge.score
          }
        end
      end
    end
  end
end
