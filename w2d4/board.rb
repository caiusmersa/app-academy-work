require_relative 'piece.rb'
require_relative 'pos_helper.rb'

require 'colorize'

class Board
  #move_turn can be set to either :p1 or :p2
  attr_accessor :move_turn
  attr_reader :size

  def initialize
    @size = 10
    @squares = Array.new(size) { Array.new(size) {nil} }
    @move_turn = :p1
  end

  def set_up_new_game
    set_up_pieces_for_player((6..9), :p1)
    set_up_pieces_for_player((0..3), :p2)
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

  def display
    system "clear"

    draw_board
    draw_bottom_ruler
    print "\n"
  end

  # def pieces(optional color)

  #___________________________________________________________________
  private

  def draw_board
    (0...size).each do |row|
      # display left ruler
      print " #{COORD_ROW[row]} ".send(RLR_COLOR[:back])
                                 .send(RLR_COLOR[:text]) + " "

      #display men and board squares
      (0...size).each do |col|
        piece = get(row, col)

        print ((piece.nil? ? "   " : " ⚈ ")
          .send(PLR_COLOR[piece ? piece.color : nil])
          .send(BRD_COLOR[(row + col) % 2]))
      end
      print "\n"
    end
  end

  def draw_bottom_ruler
    print "\n" + " " * 4 + COORD_COL.join.send(RLR_COLOR[:back])
                                         .send(RLR_COLOR[:text])
  end

  def set_up_pieces_for_player(rows, color)
    rows.each do |row|
      (-(row % 2) + 1..size - 1).step(2).each do |col|
        set(row, col, Piece.new(color, self, [row, col]))
      end
    end
  end
end