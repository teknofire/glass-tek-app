class WelcomeController < ApplicationController
  def index    
    if signed_in? and current_user.token?
      begin
        @locations = mirror_api.try(:locations)
      rescue NotImplementedError(e)
        flash[:error] = "Error while trying to talk with the mirror api: #{e.error}"
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
