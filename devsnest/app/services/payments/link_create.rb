# frozen_string_literal: true

# Payment Link genaration
module Payments
  # Payment Link genaration
  class LinkCreate < ApplicationService
    def initialize(user, order)
      @order = order
      Razorpay.setup(ENV['RAZORPAY_KEY_ID'], ENV['RAZORPAY_KEY_SECRET'])
      Razorpay.headers = { 'Content-type' => 'application/json' }

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
        "callback_url": ENV['RAZORPAY_CALLBACK_URL'],
        "callback_method": 'get'
      }

      payment_link = Razorpay::PaymentLink.create(para_attr.to_json)

      @order.update(razorpay_payment_link_id: payment_link.id, payment_link: payment_link.short_url, status: "paylink_#{payment_link.status}")
    end

    def call
      @order.save ? @order : nil
    end
  end
end
