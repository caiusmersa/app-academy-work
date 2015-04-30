require_relative 'piece.rb'

class Board
  #move_turn can be set to either :p1 or :p2
  attr_accessor :move_turn
  attr_reader :size

  def initialize
    @size = 10
    @squares = Array.new(size) { Array.new(size) {nil} }
    @move_turn = :p1
    start_game_position
  end

  def get(row, col)
    @squares[row][col]
  end

  def set(row, col, value)
    @squares[row][col] = value
  end

  def on?(row, col)
    row >= 0 && row < size
    col >= 0 && col < size
  end

  #___________________________________________________________________
  private

  def start_game_position
    #add later: load pieces from a .yml file
    #initialize positions
  end
end