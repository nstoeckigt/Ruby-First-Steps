require_relative 'beeing.rb'

class Player < Beeing
  def initialize(position, direction)
    super(position, direction)
  end
end