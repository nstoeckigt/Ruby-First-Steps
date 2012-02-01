require_relative 'entity.rb'

class Beeing < Entity
  def initialize(position, direction)
    super(position, direction)
    @alive = true
  end

  # calculate new position
  def calculatePos(direction)
    new_position = @position.clone

    case direction
    when 'N'
      new_position.y -= 1
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
    @direction = direction
    value = Array.new
    value << @position.clone
    @position = calculatePos(direction)
    value << @position
    return value
  end

  attr_accessor :alive
end