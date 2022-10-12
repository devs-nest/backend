# frozen_string_literal: true

module Api
  module V1
    class SkillController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :admin_auth, only: %i[create update destroy]


      def create
        skills = params[:data][:attributes][:name]
        skills.each do |skill_name, logo|
          Skill.create(name: skill_name, logo: logo) if Skill.find_by(name: skill_name).nil?
        end
        render_success({ message: 'Skills created successfully' })
      end
    end
  end
end
