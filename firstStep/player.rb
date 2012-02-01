require_relative 'beeing.rb'

class Player < Beeing
  def initialize(position, direction)
    super
    @alive = true
  end
  
  attr_accessor :alive
  
end