# frozen_string_literal: true

# Payment Link generation
module Payments
  # Payment Link generation
  class LinkCreate < ApplicationService
    def initialize(user, order, redirect_url)
      @order = order

      # Set up Razorpay with API keys
      Razorpay.setup(ENV['RAZORPAY_KEY_ID'], ENV['RAZORPAY_KEY_SECRET'])
      Razorpay.headers = { 'Content-type' => 'application/json' }

      # Prepare parameters for creating a Razorpay payment link
      para_attr = {
        "amount": order.amount,
        "currency": order.currency,
        "accept_partial": false,
        "description": order.description,
        "customer": {
          "name": user.name,
          "email": user.email,
          "contact": user.phone_number
        },
        "notify": {
          "sms": true,
          "email": true
        },
        "reminder_enable": true,
        "callback_url": redirect_url || ENV['RAZORPAY_CALLBACK_URL'],
        "callback_method": 'get'
      }

      # Create a Razorpay payment link
      payment_link = Razorpay::PaymentLink.create(para_attr.to_json)

      # Update the Order object with the payment link ID, short URL, and status
      @order.update(
        razorpay_payment_link_id: payment_link.id,
        payment_link: payment_link.short_url,
        status: "paylink_#{payment_link.status}"
      )
    end

    def call
      # Save the Order object and return it if successful, otherwise return nil
      @order.save ? @order : nil
    end
  end
end
