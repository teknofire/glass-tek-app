class User < ActiveRecord::Base
  has_many :authorizations
  
  def self.create_from_hash!(hash)
    create(
      name: hash['info']['name'], email: hash['info']['email'], 
      token: hash['credentials']['token'], refresh_token: hash['credentials']['refresh_token'],
      expires_at: hash['credentials']['expires_at']
    )
  end
  
  def update_credentials(hash)
    logger.info "Updating credentials"
    logger.info hash.inspect
    
    update_attributes({
      token: hash['credentials']['token'], refresh_token: hash['credentials']['refresh_token'],
      expires_at: hash['credentials']['expires_at']
    })
  end
  
  def clear_credentials
    # update_attributes({ token: nil, refresh_token: nil, expires_at: nil })
  end
end
