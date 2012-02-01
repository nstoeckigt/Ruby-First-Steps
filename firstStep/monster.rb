require_relative 'beeing.rb'

class Monster < Beeing
  def initialize(position, direction)
    super(position, direction)
  end
  
  def calculateDirection(position)
    dx = (@position.x - position.x).abs
    dy = (@position.y - position.y).abs
    dir = Array.new
    
    case @position.y <=> position.y
    when -1
      ydir = 'S'
    else
      ydir = 'N'
    end
    case @position.x <=> position.x
    when -1
      xdir = 'O'
    else
      xdir = 'W'
    end

    case dx <=> dy
    when -1
      dir << ydir << xdir
    when 1
      dir << xdir << ydir
    end
    return dir
  end
  
  def checkStep(field)
    if field.is_a?(Rock) or field.is_a?(Border) or field.is_a?(Monster)
      return false
    else
      return true
    end
  end
  
end