require_relative 'map.rb'

# read a character without pressing enter and without printing to the screen
def getKey
  begin
    # save previous state of stty
    old_state = `stty -g`
    # disable echoing and enable raw (not having to press enter)
    system "stty raw -echo"
#    key = STDIN.getc.chr
    key = STDIN.getbyte
    # gather next two characters of special keys
    if(key == "\e")
      extra_thread = Thread.new{
#        key << STDIN.getc.chr
#        key << STDIN.getc.chr
        key << STDIN.getbyte
        key << STDIN.getbyte
      }
      # wait just long enough for special keys to get swallowed
      extra_thread.join(0.00010)
      # kill thread so not-so-long special keys don't wait on getc
      extra_thread.kill
    end
#  rescue => ex
#    puts "#{ex.class}: #{ex.message}"
#    puts ex.backtrace
  ensure
    # restore previous state of stty
    system "stty #{old_state}"
  end
  return key
end  

# get levels
levels = Array.new
levels = Dir.glob("./maps/*.lvl")
levels.sort! # selfsort

# load maps after each other until reached last one in dir
lvl = 0
levels.each do |level|
  lvl+=1
  special = 0
  map = Map.new(lvl, level)
  map.draw

  while map.won != true and map.player.alive == true
    dir = nil
    if special > 2
      special = 0
    end

    #wait for user input...
    key = getKey

    case key
    when 27 # ESC
      special+=1
    when 91 # control sequence
      special+=1
    when 79 # control sequence
      special+=1
    when 65 # Arrow Up
      if special.eql? 2
        dir = 'N'
        special = 0
      end
    when 66 # Arrow Down
      if special.eql? 2
        dir = 'S'
        special = 0
      end
    when 67 # Arrow Right
      if special.eql? 2
        dir = 'O'
        special = 0
      end
    when 68 # Arrow Left
      if special.eql? 2
        dir = 'W'
        special = 0
      end
    when 70 # ENDE
      if special.eql? 2
        special = 0
        printf("USER ABORT\n")
        exit 5
      end
    else
      puts 7.chr
    end

    if !dir.nil?
      map.reDraw(dir)
    end
  end
  
  if map.player.alive.is_false
    printf("\nYOU ARE DEAD!\n")
    exit 7
  end
  
end # level loop
exit 0