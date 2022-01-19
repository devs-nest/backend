# frozen_string_literal: true

module Api
  module V1
    # Company Resource
    class CompanyResource < JSONAPI::Resource
      attributes :id, :name
    end
  end
end
