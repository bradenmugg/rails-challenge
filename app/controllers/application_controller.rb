class ApplicationController < ActionController::API
  rescue_from ActionController::ParameterMissing, :with => :bad_request

  def bad_request
    render json: { message: 'Required params missing' }, status: :bad_request
  end
end
