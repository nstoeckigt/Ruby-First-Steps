require_relative 'entity.rb'

class Beeing < Entity
  def initialize(position, direction)
    super
  end

  # calculate new position
  def calculatePos(direction)
    new_position = @position
    
    case direction
    when 'N'
      new_position.y - 1
    when 'O'
      new_position.x += 1
    when 'S'
      new_position.y += 1
    when 'W'
      new_position.x -= 1
    end
    return new_position
  end

  # perform the step
  def doStep(direction)
    value = Array.new
    value << @position
printf("o: %02d-%02d [%d]\n", @position.y, @position.x, value.size)
    
    @position = calculatePos(direction)
    
    value << @position
printf("n: %02d-%02d [%d]\n", @position.y, @position.x, value.size)
    return value
  end
end