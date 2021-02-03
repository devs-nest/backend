# frozen_string_literal: true

class ApplicationController < ActionController::API
  include ApiRenderConcern
 # before_filter :cors_preflight_check
# def cors_preflight_check
#   if request.method == :options
#     # headers['Access-Control-Allow-Origin'] = '*'
#     # headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
#     # headers['Access-Control-Allow-Headers'] = '*'
#     # headers['Access-Control-Max-Age'] = '1728000'
#     # render :text => '', :content_type => 'text/plain'

#     headers['Access-Control-Allow-Origin'] = '*'
# headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
# headers['Access-Control-Request-Method'] = '*'
# headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
#   end
# end
  def render_resource(resource)
    if resource.errors.empty?
      render json: resource
    else
      validation_error(resource)
    end
  end

  def validation_error(resource)
    render json: {
      errors: [
        {
          status: '400',
          title: 'Bad Request',
          detail: resource.errors,
          code: '100'
        }
      ]
    }, status: :bad_request
  end
end
