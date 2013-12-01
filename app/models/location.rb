class Location < MirrorApiObject
  include GeoRuby::SimpleFeatures
  
  def initialize(data)
    @data = data
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