# == Schema Information
#
# Table name: orders
#
#  id                       :bigint           not null, primary key
#  amount                   :float(24)
#  currency                 :string(255)
#  description              :string(255)
#  payment_link             :string(255)
#  razorpay_signature       :string(255)
#  status                   :string(255)
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  razorpay_order_id        :string(255)
#  razorpay_payment_id      :string(255)
#  razorpay_payment_link_id :string(255)
#  user_id                  :integer
#
class Order < ApplicationRecord
end
