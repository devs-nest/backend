# frozen_string_literal: true

module Api
  module V1
    class MarkdownController < ApplicationController
      before_action :user_auth, only: %i[index]
    end
  end
end
