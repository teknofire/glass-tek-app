class LocationList < MirrorApiObject
  def initialize(data)
    # raise NotImplementedError, "Unknown response type" if self.implements?(data['kind'])
    Rails.logger.info data.inspect
    
    @locations = data['items'].collect do |l|
      Location.new(l)
    end
  end
  
  def kind
    'mirror#locationsList'
  end
  
  def latest
    @locations.select { |l| l.id == 'latest' }.first
  end
  
  def [](key)
    @locations[key]
  end
  
  def each(&block)
    @locations.each do |l|
      yield l
    end
  end
end