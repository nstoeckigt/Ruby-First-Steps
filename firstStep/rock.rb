class Rock < Entity
  def initialize(position)
    super(position)
  end
  
  def doFall
    value = Array.new
    value << @position.clone
    @position.y += 1
    value << @position
    return value
  end
  
end