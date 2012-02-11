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
    @exit = nil
    @player = nil
    @monsters = Array.new
    @rocks = Array.new
    loadMap
    @file.close
  end
  
  # check for entities
  def analyse(sign, pos)
    if sign.eql? "+"
      @map[pos.y][pos.x] = Border.new(pos)
    end
    if sign.eql? " "
      @map[pos.y][pos.x] = Entity.new(pos)
    end
    if sign.eql? "]"
      exit = Exit.new(pos)
      @exit = exit
      @map[pos.y][pos.x] = exit
    end
    if sign.eql? "@"
      monster = Monster.new(pos, 'S')
      @monsters << monster.clone
      @map[pos.y][pos.x] = @monsters[@monsters.length-1]
    end
    if sign.eql? "#"
      rock = Rock.new(pos)
      @rocks << rock.clone
      @map[pos.y][pos.x] = @rocks[@rocks.length-1]
    end
    if sign.eql? "X"
      @player = Player.new(pos, 'S')
      @map[pos.y][pos.x] = @player
    end
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
            analyse(c, pos.clone)
            pos.x += 1
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
        #elsif field.is_a?(Entity)
        else
          mapLine << ' '
        end
      end
      printf("%s\n", mapLine)
    end
  end
  
  # draw entities changes
  def reDraw(direction)
    #check for validity of move
    if @player.alive == false
printf("dead player at '%02d:%02d'\n", @player.position.y, @player.position.x)
    end
    sPos = @player.calculatePos(direction)
    
    if @player.checkStep(@map[sPos.y][sPos.x])
      ppos = @player.doStep(direction)    
#printf("P: %02d-%02d -> %02d-%02d\n", ppos[0].y, ppos[0].x, ppos[1].y, ppos[1].x)
      @map[ppos[0].y][ppos[0].x] = Entity.new(ppos[0]) #delete old position
      @map[ppos[1].y][ppos[1].x] = @player #replace player itself
    else
      # inform player
    end
    
    @monsters.each do |monster| #for all monsters
      if monster.alive == true
        mdir = monster.calculateDirection(@player.position)
        sPos = Array.new
        sPos << monster.calculatePos(mdir[0])
        sPos << monster.calculatePos(mdir[1]) #alternative move
        if monster.checkStep(@map[sPos[0].y][sPos[0].x])
          mpos = monster.doStep(mdir[0])
        elsif monster.checkStep(@map[sPos[1].y][sPos[1].x]) #alternative move
          mpos = monster.doStep(mdir[1])
        end
        if defined? mpos and defined? mpos[0] and defined? mpos[1]
#printf("M: %02d-%02d -> %02d-%02d [%s]\n", mpos[0].y, mpos[0].x, mpos[1].y, mpos[1].x, mdir)
          if monster.position.isSame(@player.position)
            @player.alive = false 
          end
          @map[mpos[0].y][mpos[0].x] = Entity.new(mpos[0]) #delete old position
          @map[mpos[1].y][mpos[1].x] = monster #replace monster itself
        end
      else
printf("dead monster at '%02d:%02d'\n", monster.position.y, monster.position.x)
      end
    end

    @rocks.each do |rock| #for all rocks
      if rock.checkStep(@map[rock.position.y+1][rock.position.x])
        rpos = rock.doFall
#printf("R: %02d-%02d -> %02d-%02d\n", rpos[0].y, rpos[0].x, rpos[1].y, rpos[1].x)
        field = @map[rpos[1].y][rpos[1].x]
        if field.class == Monster or field.class == Player
          field.alive = false
        end
        @map[rpos[0].y][rpos[0].x] = Entity.new(rpos[0])
        @map[rpos[1].y][rpos[1].x] = rock
      end
    end
 
    draw #draw new map

    #determine win
    if @exit.position.isSame(@player.position)
      @won = true
    end
  end # reDraw

  attr_accessor :won
  attr_accessor :level
  attr_reader :exit
  attr_reader :player    
end