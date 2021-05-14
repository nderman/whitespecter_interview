# frozen_string_literal: true
class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :not_found_error_render
  rescue_from ActiveRecord::RecordInvalid, with: :validation_failed_error_render

  def not_found_error_render
    render(json: "Not found", status: :not_found)
  end

  def validation_failed_error_render(error)
    render(json: error.message, status: :unprocessable_entity)
  end
end
