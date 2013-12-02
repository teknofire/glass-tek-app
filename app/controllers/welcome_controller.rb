class WelcomeController < ApplicationController
  def index    
    fetch_mirror_api_info if signed_in?
  end
  
  def hello_self
    response = Timeline.create(current_user, 'hello self')
    
    logger.info response
    
    flash[:success] = 'Timeline entry sent'
    redirect_to '/'
  rescue NoGoogleApiTokenError => e
    flash[:warning] = "Could not find a valid mirror api token #{e}"
    redirect_to '/'
  rescue InvalidRequestError => e
    flash[:warning] = "Error performing request, #{e.message}"
    redirect_to '/'
  rescue NotAuthenticatedError => e
    logger.info e.inspect
    flash[:danger] = "Your access to the mirror api is not authorized or has expired, attempting to reaquire!"
    redirect_to '/'
  rescue UnknownRequestError => e
    flash[:warning] = "Error performing request, #{e.message}"
    redirect_to '/'    
  end
  
  protected
  
  def fetch_mirror_api_info
    @location = Location.find(current_user, 'latest')
    @timeline = Timeline.all(current_user)
  rescue NoGoogleApiTokenError => e
    flash[:warning] = "Could not find a valid mirror api token #{e.message}"    
  rescue NotAuthenticatedError =>e
    flash[:danger] = "Your access to the mirror api is not authorized or has expired, attempting to reaquire! #{e.message}"
  rescue UnknownRequestError => e
    flash[:warning] = "Error performing request, #{e.message}"
  rescue InvalidRequestError => e
    flash[:warning] = "Error performing request, #{e.message}"
  end
end
