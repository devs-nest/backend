# frozen_string_literal: true

module Api
  module V1
    # resource for the orders
    class OrderResource < JSONAPI::Resource
      caching
      attributes :amount, :currency, :description, :status, :razorpay_order_id, :pay_link_id, :razorpay_signature

      def amount
        @model.amount / 100
      end
    end
  end
end
