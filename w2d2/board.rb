
require_relative 'piece.rb'

require 'byebug'
require 'colorize'
require 'yaml'

class Board
  attr_accessor :squares, :selected_piece, :selected_sq
  attr_accessor :white_name, :black_name
  attr_accessor :player_turn, :count

  def initialize(init = true)
    @squares = Array.new(8) { Array.new(8) }
    @selected_piece = nil
    @selected_sq = [3,3]
    # @squares = YAML::load(File.read("init.yml"))  #See history.log
    set_new_game_positions if init
    @player_turn = :W if init
    @count = 2
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
    #awesomeness
  end

  def display_board(clear = false)
    system("clear") if clear
    puts "\n\n\n"
    puts "It is turn #{@count / 2}"
    highlight = selected_piece.valid_moves if selected_piece
    puts "#{white_name}, it is your move!".green if player_turn == :W
    puts "#{black_name}, it is your move!".green if player_turn == :B
    print "#{player_turn == :W ? "White" : "Black"}'s turn. "
    puts in_check?(player_turn) ? "You're in check!" : ""
    @squares.each_with_index do |row, i|
      print (" " + (8 - i).to_s + " ").yellow.on_magenta
      print " "
      row.each_with_index do |piece, j|
        to_print = "   " if piece.nil?
        to_print =  " " + piece.display + " " unless piece.nil?
        to_print = piece && piece.color == :B ? to_print.black : to_print.red
        # to_print = to_print.light_red if piece && piece == selected_piece && selected_piece.color == :W
        # to_print = to_print.light_magenta if piece && piece == selected_piece && selected_piece.color == :B
        if highlight && highlight.include?([i, j])
          to_print = (i + j) % 2 == 1 ? to_print.on_green : to_print.on_yellow
          # to_print = to_print.on_green
        else
          to_print = (i + j) % 2 == 1 ? to_print.on_blue : to_print.on_white
        end

        to_print = to_print.on_magenta if selected_sq == [i, j]
        print to_print
      end
      puts ""
    end
    puts "   ".on_magenta
    print "    ".yellow.on_magenta
    puts " a  b  c  d  e  f  g  h ".yellow.on_magenta
    # puts ""
    # puts "White in check: #{in_check?(:W)}"
    # puts "Black in check: #{in_check?(:B)}"
    # puts ""
    # puts "White checkmated?: #{checkmated?(:W)}"
    # puts "Black checkmated?: #{checkmated?(:B)}"
    # puts ""

    nil
  end

  def deep_dup
    dup_board = Board.new(false)
    pieces = squares.flatten.compact
    pieces.each do |piece|
      row, col = piece.pos[0], piece.pos[1]
      dup_board.squares[row][col] = piece.deep_dup(dup_board)
    end

    dup_board.player_turn = player_turn
    dup_board
  end

  def in_check?(color)
    king_pos = find_king_pos(color)
    opponent_pieces = all_pieces(opp_color(color))
    opponent_pieces
      .map { |piece| piece.spaces_threatened }
      .inject(&:+)
      .include?(king_pos)
  end

  def no_moves_left?(color)
    all_pieces(color).map { |piece| piece.valid_moves }
      .inject(&:+)
      .empty?
  end

  def game_over?
    checkmated?(:W) || checkmated?(:B)
    #add conditions for draw (stalemate)
  end

  def checkmated?(color)
    no_moves_left?(color) && in_check?(color)
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
    self.selected_piece = nil
  end

  def square(pos)
    return nil unless pos.all? { |coord| (0..7).include?(coord) }
    @squares[pos[0]][pos[1]]
  end

  def set_square(pos, piece)
    squares[pos[0]][pos[1]] = piece
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

  def win
    start_time = Time.now
    until Time.now - start_time > 6
      puts File.read("win_art_blank.txt").yellow
      sleep(0.2)
      system('cls')
      puts File.read("win_art_right1.txt").blue
      sleep(0.2)
      system('cls')
      puts File.read("win_art_blank.txt").yellow
      sleep(0.2)
      system('cls')
      puts File.read("win_art_left.txt").red
      sleep(0.2)
      system('cls')
      puts File.read("win_art_blank.txt").yellow
      sleep(0.2)
      system('cls')
      puts File.read("win_art_right2.txt").green
      sleep(0.2)
      system('cls')
      puts File.read("win_art_blank.txt").yellow
      sleep(0.2)
      system('cls')
      puts File.read("win_art_left.txt").magenta
      sleep(0.2)
      system('cls')
      puts File.read("win_art_blank.txt").yellow
    end
  end

  def opp_color(color)
    color == :B ? :W : :B
  end
end
