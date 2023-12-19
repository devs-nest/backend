# == Schema Information
#
# Table name: product_discounts
#
#  id         :bigint           not null, primary key
#  discount   :decimal(10, 2)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  product_id :integer
#
class ProductDiscount < ApplicationRecord
end
