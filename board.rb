require 'byebug'
require_relative 'tile'

class Board

  attr_accessor :grid

  def initialize
    @grid = setup_grid
  end

  def setup_grid
    output = Array.new(9) { Array.new(9) { Tile.new } }

    possible_positions = random_positions(9, 9)

    9.times do
      pos = possible_positions.pop
      output[pos[0]][pos[1]].bomb = true
      update_adjacent_bomb(output, pos)
    end

    output
  end

  def render
    puts "  #{(0...@grid.length).to_a.join(" ")}"
    @grid.each_with_index do |row, idx|
      to_s_row = row.map {|tile| tile.to_s}
      puts "#{idx} #{to_s_row.join(" ")}"
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
    possible_positions = []
    (0...rows).each do |i|
      (0...cols).each {|j| possible_positions << [i, j]}
    end

    possible_positions.shuffle
  end

  def update_adjacent_bomb(output, pos)
    position_differentials = [-1,0,1].permutation(2).to_a + [[1, 1], [-1, -1]]

    position_differentials.each do |diff|
      new_pos = [pos[0] + diff[0], pos[1] + diff[1]]
      if (0...9).include?(new_pos[0]) && (0...9).include?(new_pos[1])
        output[new_pos[0]][new_pos[1]].adjacent_bombs += 1
      end
    end
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
board.render
