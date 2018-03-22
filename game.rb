class Game

  attr_accessor :board

  def initialize
    @board = Board.new
  end

  def run
    until over?
      render
      take_turn
    end
  end

  def over?
    @board.over?
  end

  def render
    system("clear")
    @board.render
  end

  def take_turn
    pos = nil
    action = nil

    until valid_pos?(pos) && valid_action?(action)

    end
  end

  private

  def valid_pos?(pos)

  end

  def valid_action?(action)

  end

end
