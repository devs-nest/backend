# frozen_string_literal: true

module Api
  module V1
    # allows challenges api calls to challenge resources
    class ChallengeController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :simple_auth, only: %i[submission]

      def context
        { challenge_id: params[:id], user: @current_user }
      end

      def leaderboard
        challenge = Challenge.find_by(id: params[:id])
        algo_lb = challenge.generate_leaderboard
        algo_lb.page_size = params[:size] || 10
        page = params[:page].to_i

        scoreboard = algo_lb.leaders(page)
        pages_count = algo_lb.total_pages

        if @current_user
          rank = algo_lb.rank_for(@current_user.username)
          if rank.present?
            user = {
              name: @current_user.username,
              rank: rank,
              score: algo_lb.score_for(@current_user.username)
            }
          end
          return render_success({ id: page, type: 'challenge_leaderboard', user: user, scoreboard: scoreboard, rank: rank, count: pages_count })
        end

        render_success({ id: page, type: 'challenge_leaderboard', scoreboard: scoreboard, count: pages_count })
      end

      def fetch_by_slug
        slug = params[:slug]
        challenge = Challenge.find_by(slug: slug)
        return render_not_found('challenge') if challenge.nil?

        sample_test_cases = challenge.fetch_sample_test_cases
        challenge_hash = challenge.as_json.except('input_format', 'output_format')
        supported_languages = challenge.supported_languages.select(:id, :name, :judge_zero_id, :language_description).as_json

        data = [challenge_hash, sample_test_cases, { 'type' => 'challenge', supported_languages: supported_languages }]
        data_hash = data.inject(&:merge)

        api_render(200, data_hash)
      end

      def submissions
        challenge_id = params[:id]
        challenge = Challenge.find(challenge_id)
        all_submissions = Rails.cache.fetch("algo_submissions_#{@current_user&.id}_#{challenge_id}", expires_in: 12.hours) do
          @current_user.algo_submissions.where(challenge_id: challenge_id, is_submitted: true).where.not(status: 'Stale').as_json
        end
        # all_submissions = @current_user.algo_submissions.where(challenge_id: challenge_id, is_submitted: true).where.not(status: "Stale").as_json
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

        challenge.supported_languages.pluck(:id, :name, :judge_zero_id).each do |language|
          template = challenge.algo_templates.find_by(challenge_id: challenge_id, language_id: language[0]) # FIX
          template = challenge.create_template(language) if template.nil?
          next if template.nil?

          templates[language[1]] = template.as_json.merge!(judge_zero_id: language[2])
        end

        api_render(200, { id: challenge_id, type: 'challenge', templates: templates })
      end

      def next_question
        current_question = Challenge.find_by(id: params[:current_question_id])
        topic = current_question.topic
        topic_challenge_ids = Challenge.where(topic: topic, is_active: true).pluck(:id)
        user_success_topic_challenge_ids = UserChallengeScore.where(user_id: @current_user.id, challenge_id: topic_challenge_ids).pluck(:challenge_id)
        relevent_unsolved_submissions = topic_challenge_ids - user_success_topic_challenge_ids

        if relevent_unsolved_submissions.empty?
          all_submitted_challenges = UserChallengeScore.where(user_id: context[:user].id).pluck(:challenge_id)
          relevent_unsolved_submissions = Challenge.where(is_active: true).pluck(:id) - all_submitted_challenges
        end

        return nil if relevent_unsolved_submissions.empty?

        question_slug = Challenge.find(relevent_unsolved_submissions[0]).slug
        render_success({ slug: question_slug, type: 'challenge' })
      end
    end
  end
end
