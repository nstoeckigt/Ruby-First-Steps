require_relative 'entity.rb'

class Beeing < Entity
  def initilize(position, direction)
    super(position, direction)
  end

  def doStep(direction)
    value = Array.new
    value << @position
printf("o: %02d-%02d [%d]\n", @position.y, @position.x, value.size)
    
    case direction
    when 'N'
      @position.y -= 1
    when 'O'
      @position.x += 1
    when 'S'
      @position.y += 1
    when 'W'
      @position.x -= 1
    end
    
    value << @position
printf("n: %02d-%02d [%d]\n", @position.y, @position.x, value.size)
    return value
  end
end