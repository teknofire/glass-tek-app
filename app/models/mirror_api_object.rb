class MirrorApiObject
  def kind
    raise NotImplementedError, 'Kind not set'
  end
  
  def implements?(kynd)
    self.kind == kynd
  end
end