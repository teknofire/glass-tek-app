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
    parse_response self.class.get("/mirror/v1/locations")
    
  end
  
  def parse_response(resp)
    @response = resp
    return false if @response.include?('kind')
    
    case @response['kind']
    when 'mirror#locationsList'
      LocationList.new(@response['item'])
    end
  end
end