# frozen_string_literal: true

module Api
  module V1
    # Product Prices to get the prices
    class ProductPricesController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :user_auth

      def active_courses
        user_courses = CourseModuleAccess.where(accessor: @current_user, status: 'granted').pluck(:course_module_id)
        product_prices = ProductPrice.where(active: true, product_type: 'Course')
        data = []

        product_prices.each do |product_price|
          data << {
            "course_name": product_price.product_name,
            "course_price": product_price.price,
            "paid": (user_courses & product_price.product_id).present?,
            "course_id": product_price.product_id
          }
        end

        render_success(data: data)
      end
    end
  end
end
