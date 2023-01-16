# == Schema Information
#
# Table name: user_integrations
#
#  id                   :bigint           not null, primary key
#  gfg_user_name        :string(255)
#  hackerrank_user_name :string(255)
#  leetcode_user_name   :string(255)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  user_id              :integer
#
class UserIntegration < ApplicationRecord
  include ApplicationHelper
  belongs_to :user
end
