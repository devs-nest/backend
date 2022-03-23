# frozen_string_literal: true

module Api
  module V1
    # Discussion Resource
    class DiscussionResource < JSONAPI::Resource
      attributes :parent_id, :user_id, :challenge_id, :title, :body, :created_at, :updated_at
      attributes :upvote_count, :comments_count
      attributes :username, :user_image_url, :upvoted

      filter :challenge_id
      filter :parent_id
      filter :user_id

      def upvote_count
        @model&.upvotes&.count || 0
      end

      def comments_count
        Discussion.where(challenge_id: @model&.challenge_id, parent_id: @model&.id)&.count || 0
      end

      def username
        @user = @model.user
        @user.username
      end

      def user_image_url
        @user.image_url
      end

      def upvoted
        return true if @model&.upvotes&.where(user_id: context[:user]&.id).exists?

        false
      end
    end
  end
end
