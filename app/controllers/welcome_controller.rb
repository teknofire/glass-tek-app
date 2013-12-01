class WelcomeController < ApplicationController
  def index    
    if signed_in?
      begin
        @timeline = mirror_api.timeline
        @locations = mirror_api.locations
        if !@locations
          flash[:danger] = "#{mirror_api.error[1]} - #{mirror_api.error[2].collect{|e| e['message'] }.join(', ')}"
        end
      rescue NotAuthenticatedError
        redirect_to '/login'
      rescue NotImplementedError => e
        flash[:danger] = "Error while trying to talk with the mirror api: #{e.inspect}"
        default_locations
      end
    end
    
    default_locations unless @locations
  end
  
  protected
  
  def default_locations
    flash[:info] = "Unable to access location information, using test data"
    @locations = LocationList.new({"kind"=>"mirror#locationsList", "items"=>[{"kind"=>"mirror#location", "id"=>"latest", "timestamp"=>"2013-11-30T23:09:16.588Z", "latitude"=>64.8363861, "longitude"=>-147.8712104, "accuracy"=>20.0}]})
  end
end
