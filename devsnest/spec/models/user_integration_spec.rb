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
require 'rails_helper'

RSpec.describe UserIntegration, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
