class MirrorAPI
  include HTTParty
  base_uri 'www.googleapis.com:443'
  
  def initialize(user)
    @user = user
    self.class.default_params( { "access_token" => @user.token } )
  end
  
  def timeline
    self.class.get("/mirror/v1/timeline")
  end
  
  def locations
    self.class.get("/mirror/v1/locations")
  end
end