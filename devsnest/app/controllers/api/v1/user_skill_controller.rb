# frozen_string_literal: true

module Api
  module V1
    # Controller
    class UserSkillController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :user_auth

      def index
        api_render(200, {id: nil, skills: @current_user.skills.as_json})
      end

      def create
        data = params[:data][:attributes][:skills]

        ActiveRecord::Base.transaction do
          data.each do |skill|
            u_skill = @current_user.user_skills.find_by(skill_id: skill[:id])

            if u_skill.present?
              u_skill.update(level: skill[:level])
            else
              @current_user.user_skills.create(skill_id: skill[:id], level: skill[:level])
            end
          end
        end
        render_success(message: "Skills added")
      rescue => e
        render_error("Something went wrong: #{e}")
      end
    end
  end
end
