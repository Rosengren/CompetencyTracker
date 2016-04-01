class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper

  before_filter :current_user, :permission_check, :check_if_logged_on

  def current_user
    @current_user ||= User.find_by(id: session[:session_key])
  end

  def permission_check
    @permission = @current_user!=nil ? @current_user.permission_level : 0
  end

  # Check if logged in, and if not, then redirect
  def check_if_logged_on
    #get the current path and verify that the users are logged in, or trying to login/signup
    controller = controller_name
    action = action_name
    if request.path != "/login" && request.path != "/signup" && !(controller == "users" && action == "create")
      redirect_to :login if @current_user.nil?
    end
  end

 # Check if trying to access the admin page as a non-admin
  def check_if_admin_access
    if request.path == "/admin" && current_user.permission_level <= 2
      redirect_to :back
    end
  end
end
