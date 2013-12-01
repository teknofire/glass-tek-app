class LocationList < MirrorApiObject
  default_path '/mirror/v1/locations'
  attr_reader :locations
  
  def initialize(data)
    # raise NotImplementedError, "Unknown response type" if self.implements?(data['kind'])
    @locations = data['items'].collect do |l|
      Location.new(l)
    end
  end
  
  def kind
    'mirror#locationsList'
  end
  
  def self.find(user, id)
    Location.find(user, id)
  end
  
  def self.all(user)
    LocationList.new(super(user)).locations
  end  
end