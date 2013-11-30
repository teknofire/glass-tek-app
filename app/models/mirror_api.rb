class MirrorAPI
  include HTTParty
  base_uri 'www.googleapis.com'
  
  def initialize(user)
    super
    @user = user
  end
  
  def timeline
    options = { :headers => { "Authorization" => @user.token } }
    self.class.get("/mirror/v1/timeline", options)
  end
end