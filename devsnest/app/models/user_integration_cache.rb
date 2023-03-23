# == Schema Information
#
# Table name: user_integration_caches
#
#  id                  :bigint           not null, primary key
#  gfg_cache           :text(16777215)
#  github_cache        :text(16777215)
#  hackerrank_cache    :text(16777215)
#  leetcode_cache      :text(16777215)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  user_integration_id :integer
#
class UserIntegrationCache < ApplicationRecord
  include ApplicationHelper
  belongs_to :user_integration
end
