# frozen_string_literal: true

module Api
  module V1
    class CertificationResource < JSONAPI::Resource
      attributes :id, :user_id, :user_name, :hackathon_name, :rank, :team_name, :title, :uuid, :description, :issuing_date, :name, :certificate_type
    end
  end
end
