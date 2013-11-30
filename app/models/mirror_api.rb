class MirrorAPI
  include HTTParty
  base_uri 'www.googleapis.com:443'
  
  def initialize(user)
    @user = user
    self.class.headers( { "Authorization" => @user.token } )
  end
  
  def timeline
    self.class.get("/mirror/v1/timeline")
  end
end