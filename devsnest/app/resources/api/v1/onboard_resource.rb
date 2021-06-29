# frozen_string_literal: true

module Api
  module V1
    class OnboardResource < JSONAPI::Resource
      attributes :discord_username, :discord_id, :name, :college, :college_year, :school, :work_exp, :known_from, :dsa_skill, :webd_skill
      attributes :user_id
    end
  end
end
