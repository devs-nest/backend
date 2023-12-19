# frozen_string_literal: true

module Api
    module V1
      # Product Discount Resourse
      class ProductDiscountResource < JSONAPI::Resource
        attributes :product_id, :discount
      end
    end
  end