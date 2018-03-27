require 'colorize'

class Tile

  attr_accessor :revealed, :bomb, :flagged, :adjacent_bombs

  def initialize(bomb = false)
    @bomb = bomb
    @revealed = false
    @flagged = false
    @adjacent_bombs = 0
  end

  # def to_s
  #   if @revealed
  #     return '*'.colorize(:background => :red) if @bomb
  #     return @adjacent_bombs.to_s if @adjacent_bombs > 0
  #     " "
  #   else
  #     @flagged ? 'F' : " ".colorize(:background => :light_blue)
  #   end
  # end

  def to_s
    # display for testing only
    if @bomb
      return '*'.colorize(:background => :red)
    elsif @flagged
      return 'F' if @revealed
      return 'F'.colorize(:background => :light_blue) if !@revealed
    elsif @adjacent_bombs > 0
      return @adjacent_bombs.to_s if @revealed
      return @adjacent_bombs.to_s.colorize(:background => :light_blue) if !@revealed
    else
      return ' ' if @revealed
      return ' '.colorize(:background => :light_blue) if !@revealed
    end
  end

  def reveal
    @revealed = true
  end

  def flag
    @flagged = flagged ? false : true
  end
end
