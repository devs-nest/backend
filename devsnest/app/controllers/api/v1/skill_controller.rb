# frozen_string_literal: true

module Api
  module V1
    class SkillController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :admin_auth, only: %i[create destroy]


      def create
        skills = params[:data][:attributes][:name]
        skills.each do |skill_name, logo|
          Skill.create(name: skill_name, logo: logo) if Skill.find_by(name: skill_name).nil?
        end
        render_success({ message: 'Skills created successfully' })
      end

      def destroy
        skills = params[:data][:attributes][:name]
        skills.each do |skill_name|
          Skill.find_by(name: skill_name).destroy
        end
        render_success({ message: 'Skills deleted successfully' })
      end
    end
  end
end
