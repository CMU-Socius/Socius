class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  include ApplicationHelper

  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "You do not have access to this page."
      redirect_to home_path
  end

  def page_not_found
    respond_to do |format|
      format.html { render template: 'errors/404.html', layout: 'layouts/application', status: 404 }
      format.all  { render nothing: true, status: 404 }
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "You have no access to this page"
    redirect_to home_path
  end

  # @@firebase = Firebase::Client.new('https://socius2-1254.firebaseio.com/')

  private
  #Handling authentication

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
    rescue ActiveRecord::RecordNotFound
  end
  helper_method :current_user

  def logged_in?
    current_user
  end
  helper_method :logged_in?

  def check_login
    redirect_to login_url, alert: "You need to log in to view this page" if current_user.nil?
  end
    
end
