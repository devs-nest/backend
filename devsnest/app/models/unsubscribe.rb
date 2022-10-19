# frozen_string_literal: true

# == Schema Information
#
# Table name: unsubscribes
#
#  id         :bigint           not null, primary key
#  category   :integer          default("default")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#
# Indexes
#
#  index_unsubscribes_on_user_id_and_category  (user_id,category) UNIQUE
#
class Unsubscribe < ApplicationRecord
  belongs_to :user
  validates_uniqueness_of :user_id, scope: :category
  enum category: %i[default]
end
