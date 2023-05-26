# frozen_string_literal: true

# Verify Payment
class Payments::Verify < ApplicationService
  def initialize(order)
    @order = order
    Razorpay.setup(ENV['RAZORPAY_KEY_ID'], ENV['RAZORPAY_KEY_SECRET'])
    Razorpay.headers = { 'Content-type' => 'application/json' }
    # payment_response = { "razorpay_order_id": @order.razorpay_order_id, "razorpay_payment_id": @order.razorpay_payment_id, "razorpay_signature": @order.razorpay_signature }

    response = Razorpay::Payment.fetch(@order.razorpay_payment_id)

    @order.update(status: response.status.exists? ? response.status : 'Pending')
  end

  def call
    @order.save ? @order : nil
  end
end
