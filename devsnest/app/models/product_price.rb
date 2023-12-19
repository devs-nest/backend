# == Schema Information
#
# Table name: product_prices
#
#  id           :bigint           not null, primary key
#  price        :integer
#  product_type :string(255)      not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  product_id   :integer          not null
#
class ProductPrice < ApplicationRecord
    serialize :product_id, Array
end
