class ApplicationController < ActionController::Base
  before_action :gon_current_user, unless: :devise_controller?

  def gon_current_user
    gon.current_user = current_user&.id
  end
end
