class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_content

  private

  def render_not_found(exception)
    render json: { 
      error: 'Record not found' 
    }, status: :not_found
  end

  def render_unprocessable_content(exception)
    render json: {
      error: 'Validation failed',
      details: exception.record.errors.full_messages
    }, status: :unprocessable_content
  end
end
