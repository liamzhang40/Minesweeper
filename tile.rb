class Tile

  attr_accessor :revealed, :bomb, :flagged, :adjacent_bombs

  def initialize(bomb = false)
    @bomb = bomb
    @revealed = false
    @flagged = false
    @adjacent_bombs = 0
  end

  def to_s
    if @revealed
      return 'B' if @bomb
      return @adjacent_bombs.to_s if @adjacent_bombs > 0
      "_"
    else
      @flagged ? 'F' : "*"
    end
  end

  def revealed_bomb?
    @bomb && @revealed
  end
end
