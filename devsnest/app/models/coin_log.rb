# frozen_string_literal: true

# == Schema Information
#
# Table name: coin_logs
#
#  id             :bigint           not null, primary key
#  coins          :integer          default(0)
#  description    :text(65535)
#  pointable_type :string(255)
#  title          :string(255)
#  pointable_id   :integer
#
class CoinLog < ApplicationRecord
  belongs_to :pointable, polymorphic: true
  belongs_to :user
end
