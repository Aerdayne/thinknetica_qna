class ApplicationController < ActionController::Base
  before_action :gon_current_user, unless: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden, content_type: 'text/html' }
      format.html { redirect_to root_url, alert: exception.message }
      format.js   { head :forbidden, content_type: 'text/html' }
    end
  end

  def gon_current_user
    gon.current_user = current_user&.id
  end

  check_authorization unless: :devise_controller?
end
