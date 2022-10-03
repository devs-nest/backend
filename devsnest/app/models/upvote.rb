# frozen_string_literal: true

# == Schema Information
#
# Table name: upvotes
#
#  id           :bigint           not null, primary key
#  content_type :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  content_id   :integer
#  user_id      :integer
#
# Indexes
#
#  index_upvotes_on_user_id_and_content_id_and_content_type  (user_id,content_id,content_type) UNIQUE
#
class Upvote < ApplicationRecord
  belongs_to :content, polymorphic: true
  belongs_to :user
  validates :user_id, uniqueness: { scope: %i[content_id content_type] }
end
