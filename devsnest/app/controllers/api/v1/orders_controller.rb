# frozen_string_literal: true

module Api
  module V1
    # Controller for managing orders
    class OrdersController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :user_auth
      # Set user context for authorization
      def context
        { user: @current_user }
      end

      # POST /orders to create an order
      def create
        # Call Payments::Create service to create a payment/order
        return render_error('Amount in not correct') unless params[:amount].present? && params[:amount].to_i == ENV['APPLICATION_FEE'].to_i

        @order = Payments::Create.call(@current_user, params[:amount], params[:currency], params[:description])
        return render_error('Order not created') unless @order

        render_success(@order)
      end

      # POST /verify_payment to verify a payment
      def verify_payment
        # Check if the payment status is 'paid'
        return render_error('Payment Failed') if params[:razorpay_payment_link_status] != 'paid'

        # Find the order associated with the payment link ID
        order = Order.where(user_id: @current_user.id, razorpay_payment_link_id: params[:razorpay_payment_link_id]).first

        if order.present?
          # Update the order with the signature and payment ID
          order.update(razorpay_signature: params[:razorpay_signature], razorpay_payment_id: params[:razorpay_payment_id])

          # Call Payments::Verify service to verify the payment
          response = Payments::Verify.call(order)
          college_student = CollegeStudent.find_by(user_id: order.user_id)
          college_student.update(state: 5) if college_student.present?
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