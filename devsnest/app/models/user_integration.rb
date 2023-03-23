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
  has_one :user_integration_cache
  alias_attribute :cache, :user_integration_cache

  def set_cache(profile, platform)
    data = {
      metadata: profile,
      valid_till: Date.today + 24.hours
    }
    
    if not cache
      UserIntegrationCache.create!(user_integration_id: id)
      reload
    end

    cache.update_attribute(platform, Base64.encode64(data.to_json))
  end
end
