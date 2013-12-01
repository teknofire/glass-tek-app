class WelcomeController < ApplicationController
  def index    
    fetch_mirror_api_info if signed_in?
  end
  
  protected
  
  def fetch_mirror_api_info
    # @timeline = mirror_api.timeline
    @location = Location.find(current_user, 'latest')
  rescue NoGoogleApiTokenError
    flash[:warning] = "Could not find a valid mirror api token"    
  rescue NotAuthenticatedError
    flash[:danger] = "Your access to the mirror api is not authorized or has expired, attempting to reaquire!"
    redirect_to '/login'
  end
end
