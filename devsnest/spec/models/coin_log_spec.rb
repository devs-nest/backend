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
require 'rails_helper'

RSpec.describe CoinLog, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
