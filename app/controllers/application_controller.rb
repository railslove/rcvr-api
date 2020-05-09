class ApplicationController < ActionController::API
  before_action :set_raven_context
  before_action :set_default_request_format

  rescue_from StandardError, with: :render_internal_error
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity_response

  private

  def set_default_request_format
    request.format = :json
  end

  def set_raven_context
    Raven.user_context(id: current_user&.id)
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end

  def render_unprocessable_entity_response(exception)
    render json: exception.record.errors, status: :unprocessable_entity
  end

  def record_not_found(error)
    render json: { message: error.message }, status: :not_found
  end

  def render_internal_error(error)
    response = { message: error.message, name: error.class.name }
    response[:backtrace] = error.backtrace

    render json: response, status: :internal_server_error
  end
end
