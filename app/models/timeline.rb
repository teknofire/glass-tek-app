class Timeline < MirrorApiObject
  # base_uri 'tek-app.dev'
  default_path '/mirror/v1/timeline'
  # debug true
  
  def initialize(data)
    @data = data
  end
  
  def id
    @data['id']
  end
  
  def self_link
    @data['selfLink']
  end
  
  def text
    @data['text']
  end
  
  def self.create(user, text)
    super(user, { text: text, notification: { level: 'DEFAULT' }, menuItems: [{ action: 'READ_ALOUD' }, { action: 'DELETE' }] })
  end
  
  def self.all(user)
    resp = super(user)
    resp['items'].collect do |l|
      Timeline.new(l)
    end
  end
end