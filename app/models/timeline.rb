class Timeline < MirrorApiObject
  # base_uri 'tek-app.dev'
  default_path '/mirror/v1/timeline'
  # debug true
  
  def initialize(data)
    @data = data
  end
  
  def self.create(user, text)
    super(user, { text: text })
  end
end