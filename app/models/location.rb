class Location < MirrorApiObject
  default_path '/mirror/v1/locations'
  
  include GeoRuby::SimpleFeatures
  
  def initialize(data)
    @data = data
  end
  
  def self.find(user, id)
    Location.new super(user, id)
  end
  
  def self.all(user)
    resp = super(user)
    
    resp['items'].collect do |l|
      Location.new(l)
    end
  end
  
  def id
    @data['id']
  end
  
  def timestamp
    @data['timestamp']
  end
  
  def lat
    @data['latitude']
  end
  
  def lng
    @data['longitude']
  end
  
  def accuracy
    @data['accuracy']
  end  
  
  def point
    @point ||= Point.from_coordinates([self.lng, self.lat])
  end
  
  def wkt
    point.as_wkt
  end
end