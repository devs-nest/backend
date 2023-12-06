# frozen_string_literal: true

module Api
  module V1
    # Product Discounts
    class ProductDiscountsController < ApplicationController
      include JSONAPI::ActsAsResourceController
    end
  end
end

