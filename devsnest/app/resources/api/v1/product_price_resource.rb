# frozen_string_literal: true

module Api
    module V1
      # Product Price Resourses
      class ProductPriceResource < JSONAPI::Resource
        attributes :price, :product_type, :product_id, :product_name
      end
    end
  end