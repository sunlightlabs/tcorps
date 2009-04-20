# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all 
  #protect_from_forgery
  filter_parameter_logging :password, :password_confirmation

  def require_login
    redirect_to root_path and return false unless logged_in?
  end
  
  def logged_in?
    !current_user.nil?
  end
  helper_method :logged_in?
  
  def current_user
    @current_user ||= current_session.user if current_session
  end
  helper_method :current_user
  
  def current_session
    @current_session ||= UserSession.find
  end
  helper_method :current_session
  
end