class NotAuthenticatedError < Exception
end

class NoGoogleApiTokenError < Exception
end

class InvalidRequestError < Exception
end

class MirrorApiObject
  include HTTParty
  base_uri 'www.googleapis.com:443'
  format :json
  
  def self.default_path(path = nil)
    @default_path = path unless path.nil?
    
    @default_path
  end
  
  def self.find(user, id, params = {}, path=nil, options={})
    authenticate!(user)
    
    path = @default_path if path.nil?
    path += "/#{id}"
    
    options['query'] ||= {}
    options['query'].merge! params
    
    @response = get(path, options)
    
    valid_response?
    
    @response
  end
  
  def self.all(user, params = {}, path=nil, options={})
    authenticate!(user)
    
    path = @default_path if path.nil?
    
    options['query'] ||= {}
    options['query'].merge! params
    
    @response = get(path, options)
    
    valid_response?
    
    @response
  end
  
  def self.create(user, content, path=nil, options={})
    authenticate!(user)
    
    path = @default_path if path.nil?
    
    options['query'] ||= {}
    options['query'].merge!( content )
    
    @response = post(path, options)
    
    valid_response?
    
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
  
  def self.valid_response?
    unauthorized! if @response.unauthorized?
    invalid! if @response.bad_request?
  end
  
  def self.invalid!
    raise InvalidRequestError, error
  end
  
  def self.unauthorized!
    @user.clear_credentials
    raise NotAuthenticatedError 
  end
  
  def self.authenticate!(user)
    @user ||= user
    
    raise NoGoogleApiTokenError, @user.token if @user.token.nil?
    
    self.default_params( { "access_token" => @user.token } )
  end
end