class NotAuthenticatedError < Exception
end

class NoGoogleApiTokenError < Exception
end

class InvalidRequestError < Exception
end

class UnknownRequestError < Exception
end

class MirrorApiObject
  include HTTParty
  base_uri 'www.googleapis.com:443'
  format :json
  
  def self.debug(enabled = false)
    @debug = enabled
  end
  
  def self.default_path(path = nil)
    @default_path = path unless path.nil?
    
    @default_path
  end
  
  def self.find(user, id, params = {}, path=nil, options={})
    authenticate!(user)
    
    path = @default_path if path.nil?
    path += "/#{id}"
    
    @response = get("#{path}?#{params.to_param}", options)
    
    valid_response?
    
    @response
  end
  
  def self.all(user, params = {}, path=nil, options={})
    authenticate!(user)
    
    path = @default_path if path.nil?
    
    @response = get("#{path}?#{params.to_param}", options)
    
    valid_response?
    
    @response
  end
  
  def self.create(user, content, path=nil, options={})
    authenticate!(user)
    
    path = @default_path if path.nil?
    
    options[:body] = content.to_json
    options[:headers] ||= {}
    options[:headers].merge!({ 'Content-Type' => 'application/json', "Authorization" => "Bearer #{@user.token}" })
    
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
    raise NotAuthenticatedError, error if !@debug and @response.unauthorized?
    raise InvalidRequestError, error if @response.bad_request?
    raise UnknownRequestError, error unless @response.ok?
  end
  
  def self.authenticate!(user)
    @user ||= user
    
    raise NoGoogleApiTokenError, @user.token if !@debug and @user.token.nil?
    
    self.headers( { "Authorization" => "Bearer #{@user.token}" } )
  end
end