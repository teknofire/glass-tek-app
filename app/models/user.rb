class User < ActiveRecord::Base
  has_many :authorizations
  has_many :notifications
  
  def self.create_from_hash!(hash)
    create!(params_from_hash(hash))
  end
  
  def update_from_hash!(hash)
    update_attributes!(params_from_hash(hash))
  end
  
  def update_credentials(hash)
    update_attributes({
      token: hash['token'],
      expires_at: hash['expires_at']
    })
  end
  
  def clear_credentials
    # update_attributes({ token: nil, refresh_token: nil, expires_at: nil })
  end

  protected
  
  def params_from_hash(hash)
    {
      name: hash['info']['name'], 
      email: hash['info']['email'], 
      token: hash['credentials']['token'], 
      refresh_token: hash['credentials']['refresh_token'],
      expires_at: hash['credentials']['expires_at']
    }
  end
end
