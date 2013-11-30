class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  protected
  
  def mirror_api
    if signed_in? and current_user.token?
      @mirror_api = MirrorAPI.new(current_user)
    else
      @mirror_api = nil
    end
    
    @mirror_api
  end
  
  def current_user
    @current_user ||= User.find_by_id(session[:user_id])
  end

  def signed_in?
    !!current_user
  end

  helper_method :current_user, :signed_in?, :mirror_api

  def current_user=(user)
    @current_user = user
    session[:user_id] = user.id
  end
  
  def redirect_back_or_default(default_url)
    if session[:redirect_back_to]
      redirect_to session.delete(:redirect_back_to)
    else
      redirect_to default_url
    end
  end
end
