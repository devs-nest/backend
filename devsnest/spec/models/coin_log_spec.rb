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
require 'rails_helper'

RSpec.describe CoinLog, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
