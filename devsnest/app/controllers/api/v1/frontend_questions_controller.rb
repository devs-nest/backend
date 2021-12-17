# frozen_string_literal: true

module Api
  module V1
    # frontend submission controller
    class FrontendQuestionsController < ApplicationController
      include JSONAPI::ActsAsResourceController
    end
  end
end
