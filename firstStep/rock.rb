class Rock < Entity
  def initilize(position)
    super(position)
  end
  
  def doFall
    value = Array.new
    value << @position
printf("o: %02d-%02d ->", @position.y, @position.x)
    @position.y += 1
printf("n: %02d-%02d\n", @position.y, @position.x)
    value << @position
    return value
  end
  
end