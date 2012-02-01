class Point
  include Comparable
  
  def initialize(x, y)
    @x = x
    @y = y
  end
  
  attr_accessor :x
  attr_accessor :y
end