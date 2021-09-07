# frozen_string_literal: true

module Api
  module V1
    module Admin
      # Resource
      class UserResource < JSONAPI::Resource
        attributes :id, :discord_username, :discord_id, :name, :grad_year, :school, :work_exp, :known_from, :dsa_skill, :webd_skill

        filters :is_discord_form_filled,:created_at
      end
    end
  end
end
