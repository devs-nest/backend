# frozen_string_literal: true

module Api
  module V1
    module Admin
      class JobsController < ApplicationController
        include JSONAPI::ActsAsResourceController
        before_action :admin_auth

        def create
          job_params = params[:data][:attributes].except(:skill_ids)
          skill_ids = params[:data][:attributes][:skill_ids]
          Job.create!(job_params.merge(slug: "#{job_params[:title].parameterize}-#{SecureRandom.hex(2)}").permit!)
          job_id = Job.last.id
          skill_ids.each do |skill_id|
            JobSkillMapping.create!(job_id: job_id, skill_id: skill_id)
          end
          render_success(id: Job.last.id, message: 'Job created successfully')
        end

        def update
          job_params = params[:data][:attributes].except(:skill_ids)
          skill_ids = params[:data][:attributes][:skill_ids]
          Job.find_by(id: params[:id]).update!(job_params.merge(slug: "#{job_params[:title].parameterize}-#{SecureRandom.hex(2)}").permit!)
          JobSkillMapping.where(job_id: params[:id]).destroy_all
          skill_ids.each do |skill_id|
            JobSkillMapping.create!(job_id: params[:id], skill_id: skill_id)
          end
          render_success(id: params[:id], message: 'Job updated successfully')
        end
      end
    end
  end
end
