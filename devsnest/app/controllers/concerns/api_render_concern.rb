# frozen_string_literal: true

module ApiRenderConcern
  extend ActiveSupport::Concern
  def api_render(status_code, data = {})
    render json: {
      data: {
        id: (data[:id] || data['id']),
        type: data[:type],
        attributes: data
      }
    }, status: status_code
  end

  def render_forbidden
    api_render 403, code: :forbidden, errors: ['Forbidden']
  end

  def render_unauthorized
    api_render 401, code: :unauthorized, errors: ['Unauthorized']
  end

  def render_not_found(code = nil)
    code = "#{code}_not_found" if code.present?
    api_render 404, code: code || :not_found, errors: ['Not Found']
  end

  def render_error(error_response)
    api_render 400, code: :error, error: error_response
  end

  def render_success(data = {})
    api_render 200, data
  end
end
