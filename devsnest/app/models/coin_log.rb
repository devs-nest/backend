# frozen_string_literal: true

# == Schema Information
#
# Table name: coin_logs
#
#  id             :bigint           not null, primary key
#  coins          :integer          default(0)
#  pointable_type :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  pointable_id   :integer
#  user_id        :integer
#
class CoinLog < ApplicationRecord
  belongs_to :pointable, polymorphic: true
  belongs_to :user
end
