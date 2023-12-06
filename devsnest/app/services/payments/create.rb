# frozen_string_literal: true

# Create a payment
class Payments::Create < ApplicationService
  def initialize(user, amount, currency, description, product_price_id)
    # Set up Razorpay with API keys
    Razorpay.setup(ENV['RAZORPAY_KEY_ID'], ENV['RAZORPAY_KEY_SECRET'])
    Razorpay.headers = { 'Content-type' => 'application/json' }

    # Convert amount to cents
    amount = amount.to_i * 100

    # Create a new Order object with user, amount, currency, and description
    @order = Order.new({ user_id: user.id, amount: amount, currency: currency, description: description, product_price_id: product_price_id })

    # Prepare parameters for creating a Razorpay order
    para_attr = { "amount": amount, "currency": @order.currency, "receipt": description.to_s }

    # Create a Razorpay order and assign the order ID to the Order object
    razorpay_order = Razorpay::Order.create(para_attr.to_json)

    # Call LinkCreate service to create a link for the payment
    Payments::LinkCreate.call(user, @order)

    # Update the Order object with the Razorpay order ID
    @order.update(razorpay_order_id: razorpay_order.id)
  end

  def call
    # Save the Order object and return it if successful, otherwise return nil
    @order.save ? @order : nil
  end
end
