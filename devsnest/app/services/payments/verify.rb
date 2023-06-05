# frozen_string_literal: true

# Verify Payment
class Payments::Verify < ApplicationService
  def initialize(order)
    @order = order

    # Set up Razorpay with API keys
    Razorpay.setup(ENV['RAZORPAY_KEY_ID'], ENV['RAZORPAY_KEY_SECRET'])
    Razorpay.headers = { 'Content-type' => 'application/json' }

    # Fetch the payment details from Razorpay
    response = Razorpay::Payment.fetch(@order.razorpay_payment_id)

    # Update the Order object with the payment status based on the response from Razorpay
    @order.update(status: response.status == 'captured' ? 'Paid' : 'Pending')
  end

  def call
    # Save the Order object and return it if successful, otherwise return nil
    @order.save ? @order : nil
  end
end
