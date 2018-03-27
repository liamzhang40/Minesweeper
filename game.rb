require_relative 'board'
require_relative 'tile'
require 'byebug'

class Game

  attr_accessor :board

  def initialize
    @board = Board.new
  end

  def run
    puts "Minesweeper!!!"
    until over?
      display
      take_turn
    end
    puts board.any_bomb_revealed? ? "You lost!!" : "You won!!"
  end

  def over?
    @board.over?
  end

  def display
    system("clear")
    @board.render
  end

  def take_turn
    pos, action = get_move
    if action == "r"
      board[pos].reveal
      board.update_board(pos)
    else
      board[pos].flag # don't need to update the board because no need to reveal other tiles
    end
  end

  private

  def get_move
    puts "Enter a position (ex. 2, 3)"
    begin
      pos = parse_pos(gets)
      valid_pos?(pos)
      puts "Now enter r to 'reveal' and f to 'flag'"
      action = gets.chomp
      valid_action?(action, pos)
    rescue ArgumentError => e
      puts e.message
      puts "Enter a new position"
      retry
    end
    [pos, action]
  end

  def valid_pos?(pos)
    unless pos.is_a?(Array) && pos.length == 2 && pos.all? {|n| (0...board.grid.length).include?(n)}
      raise ArgumentError.new "Invalid position entry"
    end
  end

  def valid_action?(action, pos)
    raise ArgumentError.new "Position is flagged" if action == "r" && board[pos].flagged
    raise ArgumentError.new "Can't flag a revealed position" if action == "f" && board[pos].revealed
  end

  def parse_pos(string)
    string.chomp.split(',').map(&:to_i)
  end
end


game = Game.new.run
