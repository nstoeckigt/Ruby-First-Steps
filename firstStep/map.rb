require_relative 'player.rb'
require_relative 'border.rb'
require_relative 'exit.rb'
require_relative 'monster.rb'
require_relative 'rock.rb'
require_relative 'point.rb'

class Map
  
  def initialize(level, filename)
    @won = false
    @level = level
    @file = File.open(filename, "r")
    @map = nil
    @player = nil
    @monsters = Array.new
    @rocks = Array.new
    @exit = nil
    loadMap
    @file.close
  end
  
  # check for entities
  def analyse(sign, pos)
    if sign.eql? "+"
      @map[pos.y] << Border.new(pos)
    end
    if sign.eql? " "
      @map[pos.y] << Entity.new(pos)
    end
    if sign.eql? "]"
      exit = Entity.new(pos, '')
      @exit = exit
      @map[pos.y] << exit
    end
    if sign.eql? "@"
      monster = Monster.new(pos, 'S')
      @monsters << monster
      @map[pos.y] << monster
    end
    if sign.eql? "#"
      rock = Rock.new(pos)
      @rocks << rock
      @map[pos.y] << rock
    end
    if sign.eql? "X"
      @player = Player.new(pos, 'S')
      @map[pos.y] << @player
    end
    return pos.x+1
  end
  
  # load the map
  def loadMap
    begin
      pos = Point.new(0, 0)
      @map = Array.new
      
      while (line = @file.gets)
        if line.length > 1 then
          @map << Array.new
          pos.x = 0
          line.each_char do |c|
            pos.x = analyse(c, pos)
          end #do
    
          pos.y += 1
        end
      end #while
    end
  end
  
  # draw whole map
  def draw
    system("clear")
    printf("\tLevel -%d-\n", @level)
    @map.each do |line|
      mapLine = ""
      line.each do |field|
        if field.is_a?(Border)
          mapLine << '+'
        elsif field.is_a?(Exit)
          mapLine << ']'
        elsif field.is_a?(Player)
          mapLine << 'X'
        elsif field.is_a?(Monster)
          mapLine << '@'
        elsif field.is_a?(Rock)
          mapLine << '#'
        elsif field.is_a?(Entity)
          mapLine << ' '
        end
      end
      printf("%s\n", mapLine)
    end
  end
  
  # draw entities changes
  def reDraw(direction)
    #TODO: chech for validity of move

printf("\nP: %02d-%02d\n", @player.position.y, @player.position.x)    
    ppos = @player.doStep(direction)
printf("%02d-%02d -> %02d-%02d\n", ppos[0].y, ppos[0].x, ppos[1].y, ppos[1].x)
    @map[ppos[0].y][ppos[0].x] = Entity.new(ppos[0])
    @map[ppos[1].y][ppos[1].x] = Player.new(ppos[1], direction)
    
    @rocks.each do |rock|
printf("\nR: %02d-%02d\n", rock.position.y, rock.position.x)    
      rpos = rock.doFall
printf("%02d-%02d -> %02d-%02d\n", rpos[0].y, rpos[0].x, rpos[1].y, rpos[1].x)
      @map[rpos[0].y][rpos[0].x] = Entity.new(rpos[0])
      @map[rpos[1].y][rpos[1].x] = Rock.new(rpos[1])
    end
    @monsters.each do |monster|
printf("\nM: %02d-%02d\t", monster.position.y, monster.position.x)
      mdir = monster.calculateDirection(@player.position)
      mpos = monster.doStep(mdir)
printf("%02d-%02d -> %02d-%02d [%s]\n", mpos[0].y, mpos[0].x, mpos[1].y, mpos[1].x, mdir)
      @map[mpos[0].y][mpos[0].x] = Entity.new(mpos[0])
      @map[mpos[1].y][mpos[1].x] = Monster.new(mpos[1], mdir)
    end
    draw

    #determine win
    if @exit.position.eql? @player.position
      @won = true
    end
    return true
  end # reDraw

  attr_accessor :won
  attr_accessor :level
  attr_reader :exit
    
end