# frozen_string_literal: true

module Api
  module V1
    module Admin
      # Resource
      class CertificationResource < JSONAPI::Resource
        attributes :id, :user_id, :user_name, :hackathon_name, :rank, :team_name, :title, :uuid, :description, :issuing_date, :name, :certificate_type
        paginator :paged
      end
    end
  end
end
