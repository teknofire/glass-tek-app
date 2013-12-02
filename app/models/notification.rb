class Notification < ActiveRecord::Base
  belongs_to :user
  
  before_create :generate_key
  
  def generate_key
    self.key = SecureRandom.uuid
  end
  
  def self.from_param(key)
    find_by_key(key)
  end
  
  def to_param
    self.key
  end
end
