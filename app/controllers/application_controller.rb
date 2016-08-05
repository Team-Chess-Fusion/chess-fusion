class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def render_not_found(status = :not_found)
    render text: status.to_s.titleize.to_s, status: status
  end

  def record_not_found
    render text: 'record not found', status: :not_found
  end
end
