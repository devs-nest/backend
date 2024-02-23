# frozen_string_literal: true

module Api
  module V1
    # Product Prices to get the prices
    class ProductPricesController < ApplicationController
      include JSONAPI::ActsAsResourceController
      before_action :user_auth

      def active_courses
        user_courses = CourseModuleAccess.where(accessor: @current_user, status: 'granted').pluck(:course_module_id)
        college_ids = CollegeProfile.where(user_id: @current_user.id).pluck(:college_id)
        user_courses_through_college = CourseModuleAccess.where(accessor_id: college_ids, accessor_type: 'College').pluck(:course_module_id) if college_ids
        product_prices = ProductPrice.where(active: true, product_type: 'Course')
        user_courses += user_courses_through_college
        data = []

        product_prices.each do |product_price|
          # Give all the products for admin
          next if ((user_courses & product_price.product_id).blank? && product_price.price.positive?) && !user.admin?

          data << {
            "product_id": product_price.id,
            "course_name": product_price.product_name,
            "course_price": product_price.price,
            "paid": product_price.price.zero? || (user_courses & product_price.product_id).present?,
            "course_id": product_price.product_id,
            "redirect_url": product_price.redirect_url
          }
        end

        render_success(data: data)
      end
    end
  end
end
