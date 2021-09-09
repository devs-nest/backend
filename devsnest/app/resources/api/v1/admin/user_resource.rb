# frozen_string_literal: true

module Api
  module V1
    module Admin
      # Resource
      class UserResource < JSONAPI::Resource
        attributes :id, :discord_username, :discord_id, :name, :grad_year, :school, :work_exp, :known_from, :dsa_skill, :webd_skill,
                   :group_assigned

        filters :is_discord_form_filled, :group_assigned

        filter :span, apply: lambda { |records, value, _options|
          records.where('created_at >= ?', Date.parse(value[0]))
        }
      end
    end
  end
end
