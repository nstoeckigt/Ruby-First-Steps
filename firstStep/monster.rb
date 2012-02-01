require_relative 'beeing.rb'

class Monster < Beeing
  def initialize(position, direction)
    super
  end
  
  def calculateDirection(position)
    dx = (@position.x - position.x).abs
    dy = (@position.y - position.y).abs
    
    case dx > dy
    when -1
      case @position.y <=> position.y
      when -1
        dir = 'S'
      else
        dir = 'N'
      end
    when 1
      case @position.x <=> position.x
      when -1
        dir = 'W'
      else
        dir = 'O'
      end
    end
    return dir
  end
  
end