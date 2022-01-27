# frozen_string_literal: true

module Api
  module V1
    # allows challenges api calls to challenge resources
    class ChallengeController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :simple_auth, only: %i[submission]

      def context
        { challenge_id: params[:id] }
      end

      def fetch_by_slug
        slug = params[:slug]
        challenge = Challenge.find_by(slug: slug)

        return render_not_found('challenge') if challenge.nil?

        api_render(200, challenge.as_json.merge("type": 'challenges'))
      end

      def submissions
        challenge_id = params[:id]
        challenge = Challenge.find(challenge_id)
        all_submissions = @current_user.algo_submissions.where(challenge_id: challenge_id, is_submitted: true).as_json
        all_submissions.map { |submission| submission['score_achieved'] = submission['passed_test_cases'] / submission['total_test_cases'].to_f * challenge.score }
        api_render(200, { id: challenge_id, type: 'challenge', submissions: all_submissions })
      end

      def companies
        challenge = Challenge.find(params[:id])
        return render_not_found if challenge.nil?

        render_success({ id: challenge.id, type: 'companies', companies: challenge.companies })
      end

      def template
        challenge_id = params[:id]

        challenge = Challenge.find_by(id: challenge_id)
        return render_not_found if challenge.nil?

        templates = {}

        Language.all.pluck(:id, :name, :judge_zero_id).each do |language|
          template = challenge.algo_templates.find_by(challenge_id: challenge_id, language_id: language[0]) # FIX
          template = challenge.create_template(language) if template.nil?
          next if template.nil?

          templates[language[1]] = template.as_json.merge!(judge_zero_id: language[2])
        end

        api_render(200, { id: challenge_id, type: 'challenge', templates: templates })
      end
    end
  end
end
