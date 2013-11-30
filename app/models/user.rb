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
    update_attributes({
      token: hash['credentials']['token'], refresh_token: hash['credentials']['refresh_token'],
      expires_at: hash['credentials']['expires_at']
    })
  end
end
