class User < ActiveRecord::Base
  has_many :authorizations
  
  def self.create_from_hash!(hash)
    create(name: hash['info']['name'], email: hash['info']['email'])
  end
end
