class NotAuthenticatedError < Exception
end

class NoGoogleApiTokenError < Exception
end

class MirrorApiObject
  include HTTParty
  base_uri 'www.googleapis.com:443'
  
  def self.default_path(path = nil)
    @default_path = path unless path.nil?
    
    @default_path
  end
  
  def self.find(user, id, params = {}, path=nil, options={})
    authenticate!(user)
    
    path = @default_path if path.nil?
    path += "/#{id}"
    
    @response = super("#{path}?#{params.to_param}", options)
    
    authorized?
    
    @response
  end
  
  def self.all(user, params = {}, path=nil, options={})
    authenticate!(user)
    
    path = @default_path if path.nil?
    
    @response = super("#{path}?#{params.to_param}", options)
    
    authorized?
    
    @response
  end
  
  def self.error
    [@response.code, @response.message, @response.parsed_response['error']['errors']]
  end
  
  def kind
    raise NotImplementedError, 'Kind not set'
  end
  
  def implements?(kynd)
    self.kind == kynd
  end
  
  protected
  
  
  def self.authorized?
    unauthorized! if @response.unauthorized?
  end
  
  def self.unauthorized!
    @user.clear_credentials
    raise NotAuthenticatedError 
  end
  
  def self.authenticate!(user)
    @user ||= user
    
    raise NoGoogleApiTokenError unless @user.token?
    
    self.class.default_params( { "access_token" => @user.token } )
  end
end