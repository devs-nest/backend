# frozen_string_literal: true

# Verify Payment Link State
class Payments::VerifyLink < ApplicationService
  def initialize(order)
    @order = order

    # Set up Razorpay with API keys
    Razorpay.setup(ENV['RAZORPAY_KEY_ID'], ENV['RAZORPAY_KEY_SECRET'])
    Razorpay.headers = { 'Content-type' => 'application/json' }

    # Fetch the payment details from Razorpay
    response = Razorpay::PaymentLink.fetch(@order.razorpay_payment_link_id)

    # Update the Order object with the payment status based on the response from Razorpay
    @order.update(status: response.status == 'paid' ? 'Paid' : 'Pending')
    return if @order.status != 'Paid'

    @order.update(razorpay_payment_id: response.payments[0]['payment_id'])
    college_student = CollegeStudent.find_by(user_id: @order.user_id)
    college_student.update(state: 5) if college_student.present?
  end

  def call
    # Save the Order object and return it if successful, otherwise return nil
    @order.save ? @order : nil
  end
end
