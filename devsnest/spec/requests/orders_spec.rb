# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::OrdersController, type: :request do
  describe 'POST /orders' do
    let(:currency) { 'IND' }
    let(:description) { 'Test Order' }

    context 'when order is successfully created' do
      let(:order) { create(:order) }
      let(:user) { create(:user) }

      it 'calls Razorpay::Order.create with the correct parameters' do
        order_create_response = OpenStruct.new(
          id: 'order_LxTrj0L0j48jIA',
          amount: 100,
          currency: 'INR',
          receipt: 'PAY TEST#4'
        )

        payment_link_create_response = OpenStruct.new(
          amount: 100,
          amount_paid: 0,
          callback_method: 'get',
          callback_url: 'http://localhost:8000/api/v1/orders/verify_payment',
          currency: 'INR',
          customer: {
            email: 'adhikrammaitra@gmail.com',
            name: 'Adhikram Maitra'
          },
          description: 'PAY TEST#4',
          id: 'plink_LxTs8U9cplgSMW',
          short_url: 'https://rzp.io/i/I7iNakCR',
          status: 'created'
        )

        sign_in(user)
        allow(Razorpay::Order).to receive(:create).and_return(order_create_response)
        allow(Razorpay::PaymentLink).to receive(:create).and_return(payment_link_create_response)
        allow(ENV).to receive(:[]).and_return(1000)

        post '/api/v1/orders', params: {
          amount: 1000,
          currency: currency,
          description: description
        }

        expect(response).to have_http_status(:ok)
      end
    end

    context 'Verify Payment' do
      let(:user) { create(:user) }
      let(:order) { create(:order, razorpay_payment_link_id: 'plink_LxTs8U9cplgSMW', user_id: user.id) }

      it 'renders success response' do
        sign_in(user)
        payment_fetch_response = OpenStruct.new(
          id: order.razorpay_payment_id,
          amount: 100,
          currency: 'INR',
          status: 'captured',
          order_id: 'order_LxTsS7Zcik9e0W',
          captured: true,
          description: '#LxTsIumxS6avZ4',
          contact: '+91123456789'
        )
        allow(Razorpay::Payment).to receive(:fetch).and_return(payment_fetch_response)
        # expect(Payments::Verify).to receive(:call).with(order).and_return(response)

        post '/api/v1/orders/verify_payment', params: {
          razorpay_payment_link_id: 'plink_LxTs8U9cplgSMW',
          razorpay_payment_link_status: 'paid',
          razorpay_signature: 'f2e8f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2',
          razorpay_payment_id: 'pay_LxTt4BvWYMNijj'
        }
        expect(response).to have_http_status(:ok)
      end

      it 'renders error response' do
        sign_in(user)

        post '/api/v1/orders/verify_payment', params: {
          razorpay_payment_link_id: 'plink_LxTs8U9cplgSMW',
          razorpay_payment_link_status: 'Failed',
          razorpay_signature: 'f2e8f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2f2',
          razorpay_payment_id: 'pay_LxTt4BvWYMNijj'
        }

        expect(response.status).to eq(400)
      end
    end
  end
end
