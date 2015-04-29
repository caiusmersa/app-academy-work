
require './piece.rb'
require 'byebug'
require 'colorize'
require 'yaml'

class Board
  attr_accessor :squares

  def initialize
    @squares = Array.new(8) { Array.new(8) }
    # @squares = YAML::load(File.read("init.yml"))  #See history.log
    set_new_game_positions
  end

  def set_new_game_positions
    #Place kings
    @squares[0][4] = King.new([0, 4], self, :B)
    @squares[7][4] = King.new([7, 4], self, :W)

    # Place queens
    @squares[0][3] = Queen.new([0, 3], self, :B)
    @squares[7][3] = Queen.new([7, 3], self, :W)

    # Place rooks
    @squares[0][0] = Rook.new([0, 0], self, :B)
    @squares[0][7] = Rook.new([0, 7], self, :B)
    @squares[7][0] = Rook.new([7, 0], self, :W)
    @squares[7][7] = Rook.new([7, 7], self, :W)

    # Place knights
    @squares[0][1] = Knight.new([0, 1], self, :B)
    @squares[0][6] = Knight.new([0, 6], self, :B)
    @squares[7][1] = Knight.new([7, 1], self, :W)
    @squares[7][6] = Knight.new([7, 6], self, :W)

    # Place bishops
    @squares[0][2] = Bishop.new([0, 2], self, :B)
    @squares[0][5] = Bishop.new([0, 5], self, :B)
    @squares[7][2] = Bishop.new([7, 2], self, :W)
    @squares[7][5] = Bishop.new([7, 5], self, :W)

    # Place pawns
    (0..7).each do |file|
      @squares[1][file] = Pawn.new([1, file], self, :B)
      @squares[6][file] = Pawn.new([6, file], self, :W)
    end

    # File.open("init.yml", 'w') do |file|
    #   file.puts(@squares.to_yaml)
    # end
  end
  
  def display_ascii

  end

  def display_board
    @squares.each_with_index do |row, i|
      print (" " + (8 - i).to_s + " ").yellow.on_magenta
      print " "
      row.each_with_index do |piece, j|
        to_print = "   " if piece.nil?
        to_print =  " " + piece.display + " " unless piece.nil?
        to_print = piece && piece.color == :B ? to_print.black : to_print.red
        print (i + j) % 2 == 1 ? to_print.on_blue : to_print.on_white
      end
      puts ""
    end
    puts "   ".on_magenta
    print "    ".yellow.on_magenta
    puts " a  b  c  d  e  f  g  h ".yellow.on_magenta

    nil
  end

  def in_check?(color)
    king_pos = find_king_pos(color)
    opponent_pieces = all_pieces(opp_color(color))
    all_valid_moves = []
    opponent_pieces.each { |piece| all_valid_moves += piece.valid_moves }
  end

  def inspect
    nil
  end

  def find_king_pos(color)
    @squares.each_with_index do |row, i|
      row.each_with_index do |piece, j|
        return [i, j] if piece && piece.is_a?(King) && piece.color == color
      end
    end
    raise ChessError "No #{:color} king found!"
  end

  def update_square(old_pos, new_pos)
    piece = @squares[old_pos[0]][old_pos[1]]
    @squares[old_pos.first][old_pos.last] = nil
    @squares[new_pos.first][new_pos.last] = piece
  end

  def square(pos)
    return nil unless pos.all? { |coord| (0..7).include?(coord) }
    @squares[pos[0]][pos[1]]
  end

  def all_pieces(color)
    all_pieces = []

    @squares.each do |row|
      row.each do |piece|
        all_pieces << piece if piece && piece.color == color
      end
    end

    all_pieces
  end

  def opp_color(color)
  end
end

if __FILE__ == $PROGRAM_NAME
  game = Board.new
  game.display_board
  game.update_square([7,1], [5,2])
end
