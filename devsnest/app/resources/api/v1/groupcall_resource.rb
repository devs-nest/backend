# frozen_string_literal: true

module Api
  module V1
    class GroupcallResource < JSONAPI::Resource
      attributes :user_id, :choice
    end
  end
end
