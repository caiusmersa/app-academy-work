require_relative 'piece.rb'
require_relative 'pos_helper.rb'

require 'colorize'

class Board
  #move_turn can be set to either :p1 or :p2
  attr_accessor :move_turn, :cursor
  attr_reader :size, :names, :selected_pc

  def initialize(p1_name, p2_name)
    @size = SIZE
    @names = { :p1 => p1_name, :p2 => p2_name }
    @move_turn = :p1
    @cursor = [5,5]

    @selected_sq = [[2,0]]
    @squares = Array.new(size) { Array.new(size) {nil} }
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
    row >= 0 && row < size &&
    col >= 0 && col < size
  end

  def over?
    get_moves(move_turn).empty?
  end

  def select!(piece)
    @selected_pc = piece
    @selected_sq = piece.get_moves if piece
  end

  def unselect!
    @selected_pc = nil
    @selected_sq = []
  end

  def selected?(row, col)
    @selected_sq.include?([row, col])
  end

  #private?
  def get_moves(color)
    pieces(color).map { |piece| piece.get_moves }.inject(&:+)
  end

  def pieces(color)
    @squares.flatten.compact.select { |piece| piece.color == color }
  end

  def display
    system "clear"

    draw_board
    draw_bottom_ruler_and_info
    puts "Selected: #{selected_pc.object_id}"
    p "Selected: #{@selected_sq}"
  end


  #___________________________________________________________________
  private

  def draw_board
    (0...size).each do |row|
      # display left ruler
      print " #{COORD_ROW[row]} ".send(RLR_COLOR[:back])
                                 .send(RLR_COLOR[:text]) + " "

      # display men and board squares
      (0...size).each do |col|
        piece = get(row, col)

        print ((piece.nil? ? "   " : " ⚈ ")
          .send(PLR_COLOR[piece ? piece.color : nil])
          .send(BRD_COLOR[selected?(row, col)][(row + col) % 2])
          .send(CUR_COLOR[[row, col] == cursor]))
      end
      print "\n"
    end
  end

  def draw_bottom_ruler_and_info
    # display right ruler
    puts "\n" + " " * 4 + COORD_COL.join.send(RLR_COLOR[:back])
                                        .send(RLR_COLOR[:text]) + "\n\n"
    # display player names and whose turn it is
    names_d = names.dup
    names_d[move_turn] = names_d[move_turn].send(PLR_COLOR[:turn])
    puts names_d.keys.map     { |key| " ⚈ ".send(PLR_COLOR[key]) +
                               names_d[key].send(PLR_COLOR[key])}.join "    "
  end

  def set_up_pieces_for_player(rows, color)
    rows.each do |row|
      (-(row % 2) + 1..size - 1).step(2).each do |col|
        set(row, col, Piece.new(color, self, [row, col]))
      end
    end
  end
end