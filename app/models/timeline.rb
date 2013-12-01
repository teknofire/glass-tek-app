class Timeline < MirrorApiObject
  default_path '/mirror/v1/timeline'
  
  def initialize(data)
    @data = data
  end
  
  def self.create(user, text)
    super(user, { text: text })
  end
end