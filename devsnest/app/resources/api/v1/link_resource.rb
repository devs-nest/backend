# frozen_string_literal: true

module Api
  module V1
    # Link Resourses
    class LinkResource < JSONAPI::Resource
      primary_key :slug
      key_type :string
      attributes :slug, :address
    end
  end
end
