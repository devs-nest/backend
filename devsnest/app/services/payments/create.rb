# frozen_string_literal: true

# Create a payment
class Payments::Create < ApplicationService
  def initialize(user, amount, currency, description)
    Razorpay.setup(ENV['RAZORPAY_KEY_ID'], ENV['RAZORPAY_KEY_SECRET'])
    Razorpay.headers = { 'Content-type' => 'application/json' }

    amount = amount.to_i * 100
    @order = Order.new({ user_id: user.id, amount: amount, currency: currency, description: description })

    para_attr = { "amount": amount, "currency": @order.currency, "receipt": description.to_s }

    razorpay_order = Razorpay::Order.create(para_attr.to_json)
    Payments::LinkCreate.call(user, @order)

    @order.update(razorpay_order_id: razorpay_order.id)
  end

  def call
    @order.save ? @order : nil
  end
end
