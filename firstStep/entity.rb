class Entity
  def initialize(position, direction = nil)
    @position = position
    @direction = direction
  end
  
  attr_accessor :position
  attr_accessor :direction
end