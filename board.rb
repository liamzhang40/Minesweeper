require 'byebug'
require_relative 'tile'

class Board
  POS_DIFF = [[-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1], [-1, -1]]

  attr_accessor :grid

  def initialize
    @grid = setup_grid
  end

  def setup_grid
    raw_grid = Array.new(9) { Array.new(9) { Tile.new } }

    possible_bomb_positions = random_positions(9, 9)

    9.times do
      center_pos = possible_bomb_positions.pop
      raw_grid[center_pos[0]][center_pos[1]].bomb = true

      neighbor_pos = possible_adjacent_positions(center_pos)
      neighbor_pos.each {|pos| raw_grid[pos[0]][pos[1]].adjacent_bombs += 1}
    end

    raw_grid
  end

  def render
    puts "    #{(0...@grid.length).to_a.join("   ")}"
    puts "   -----------------------------------"
    @grid.each_with_index do |row, idx|
      to_s_row = row.map {|tile| tile.to_s}
      puts "#{idx} | #{to_s_row.join(" | ")} |"
      puts "   -----------------------------------"
    end
  end

  def over?
    return true if bomb_revealed?

    revealed_tiles = 0
    (0...grid.length).each do |i|
      (0...grid[i].length).each do |j|
        revealed_tiles += 1 if grid[i][j].revealed
      end
    end

    (grid.length * grid[0].length) - revealed_tiles == 9
  end

  def update_board(pos)
    unless self[pos].bomb || self[pos].flagged# Do nothing if the revealed pos is a bomb
      # debugger
      arr = [pos] # if it is not a bomb
      until arr.empty?
        # debugger
        current_pos = arr.shift # take out the first position
        self[current_pos].reveal unless self[current_pos].bomb || self[current_pos].flagged# will reveal it unless it is a bomb

        unless self[current_pos].adjacent_bombs > 0 # will add first positions neighbors unless it has adjacent bombs
          possible_adjacent_positions(current_pos).each do |pos|
            arr << pos unless self[pos].revealed
            # will not shovel to arr if the position is already revealed or flagged
          end
        end
        # arr += possible_adjacent_positions(current_pos) unless self[current_pos].adjacent_bombs > 0

      end
    end
  end

  def [](pos)
    row, col = pos
    grid[row][col]
  end

  def []=(pos, val)
    row, col = pos
    @grid[row][col] = value
  end

  private

  def random_positions(rows, cols)
    possible_bomb_positions = []
    (0...rows).each do |i|
      (0...cols).each {|j| possible_bomb_positions << [i, j]}
    end

    possible_bomb_positions.shuffle
  end

  def possible_adjacent_positions(center_pos)
    POS_DIFF.map do |diff|
      new_pos = [center_pos[0] + diff[0], center_pos[1] + diff[1]]
      if new_pos[0].between?(0, 8) && new_pos[1].between?(0, 8)
        new_pos
      end
    end.compact
  end


  def bomb_revealed?
    (0...grid.length).each do |i|
      (0...grid[i].length).each do |j|
        return true if grid[i][j].revealed_bomb?
      end
    end
  end

end

board = Board.new
# p board.grid
