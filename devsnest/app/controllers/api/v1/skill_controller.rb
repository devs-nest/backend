module Api
  module V1
    class SkillController < ApplicationController
      include JSONAPI::ActsAsResourceController
    end
  end
end