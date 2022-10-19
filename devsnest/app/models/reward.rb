# frozen_string_literal: true

# == Schema Information
#
# Table name: rewards
#
#  id          :bigint           not null, primary key
#  description :text(65535)
#  title       :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Reward < ApplicationRecord
  has_many :coin_log, as: :pointable, dependent: :destroy
end
