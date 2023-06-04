# frozen_string_literal: true

module Api
  module V1
    # controller for the orders
    class OrdersController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :user_auth, only: %i[create]

      def context
        { user: @current_user }
      end

      # POST /orders to create order
      def create
        @order = Payments::Create.call(@current_user, params[:amount], params[:currency], params[:description])
        return render_error('Order not created') unless @order

        render_success(@order)
      end

      # POST /verify_payment to verify payment
      def verify_payment
        return render_error('Payment Failed') if params[:razorpay_payment_link_status] != 'paid'

        order = Order.where(razorpay_payment_link_id: params[:razorpay_payment_link_id]).first
        if order.present?
          order.update(razorpay_signature: params[:razorpay_signature], razorpay_payment_id: params[:razorpay_payment_id])
          response = Payments::Verify.call(order)
          render_success(response)
        else
          render_error('Order not found')
        end
      rescue StandardError => e
        render_error(e.message)
      end
    end
  end
end
