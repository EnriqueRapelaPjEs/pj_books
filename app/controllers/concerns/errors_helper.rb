module ErrorsHelper
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      render_error(Error.not_found("The requested resource doesn't exist (#{e.model} = #{e.id})"))
    end

    rescue_from StrongerParameters::InvalidParameter do |e|
      render_error(Error.invalid_parameter(e.to_s))
    end
  end

  def render_error(error)
    error.request_id = request.uuid
    render json: error.as_json, status: error.status_code
  end

  def render_validation_error(model)
    render_error(Error.field_validation_error(model))
  end
end