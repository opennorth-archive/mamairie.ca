class DateTime 
  attr_accessor :tzid
  
  def set_tzid(x)
    self.tzid = x
    self
  end
end