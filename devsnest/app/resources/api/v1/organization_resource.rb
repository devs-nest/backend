# frozen_string_literal: true

module Api
  module V1
    class OrganizationResource < JSONAPI::Resource
      attributes :name, :description, :slug, :website, :logo_banner, :logo, :heading, :created_at, :updated_at
    end
  end
end
