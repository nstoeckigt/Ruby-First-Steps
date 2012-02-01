class Entity
  
  def initialize(position, direction = nil)
    @position = position
    @direction = direction
  end
  
  def checkStep(field)
    if field.is_a?(Rock) or field.is_a?(Border)
      return false
    else
      return true
    end
  end

  attr_accessor :position
  attr_accessor :direction
end