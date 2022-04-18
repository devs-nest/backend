# frozen_string_literal: true

module Api
  module V1
    # Discussion Resource
    class DiscussionResource < JSONAPI::Resource
      attributes :parent_id, :user_id, :challenge_id, :title, :body, :created_at, :updated_at
      attributes :upvote_count, :comments_count
      attributes :username, :user_image_url, :upvoted, :upvote_id

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
        @upvote_id = @model.upvotes.find_by(user_id: context[:user]&.id)&.id
        return true if @upvote_id.present?

        false
      end

      def upvote_id
        return @upvote_id if @upvote_id.present?
      end
    end
  end
end