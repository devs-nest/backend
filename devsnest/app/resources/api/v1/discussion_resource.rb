# frozen_string_literal: true

module Api
  module V1
    # Discussion Resource
    class DiscussionResource < JSONAPI::Resource
      attributes :parent_id, :user_id, :challenge_id, :title, :body, :created_at, :updated_at
      attributes :upvote_count, :comments_count

      filter :challenge_id
      filter :parent_id
      filter :user_id

      def upvote_count
        @model.upvotes.count
      end

      def comments_count
        Discussion.where(challenge_id: @model.challenge_id, parent_id: @model.id).count
      end
    end
  end
end
