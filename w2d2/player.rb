require_relative 'input.rb'
require "io/console"

class Player
  attr_reader :board, :name

  def initialize(name, color, board)
    @name = name
    @color = color
    @board = board
  end

  def get_move
    raise ChessError.new("not yet implemented")
  end
end

class ComputerPlayer < Player
  def get_move
    sleep(rand(3) + 0.5)
    piece = @board.all_pieces(@color).reject { |piece| piece.valid_moves.empty? }.sample
    piece.make_move(piece.valid_moves.sample)
    nil
  end
end

class HumanPlayer < Player
  def initialize(color, board)
    system("clear")
    puts "#{color == :B ? "Black" : "White"} player, what is your name?"
    puts "Enter your name: ".green
    super(gets.chomp, color, board)
  end

  def get_move
    begin
      turn_over = false
      until turn_over || @board.game_over?
        board.display_board(true)
        input = ChessInput.read_char
        sel_sq = board.selected_sq
        case input
        when "\e[A"
          board.selected_sq = [[sel_sq[0] - 1, 0].max, sel_sq[1]]
        when "\e[D"
          board.selected_sq = [sel_sq[0], [sel_sq[1] - 1, 0].max]
        when "\e[B"
          board.selected_sq = [[sel_sq[0] + 1, 7].min, sel_sq[1]]
        when "\e[C"
          board.selected_sq = [sel_sq[0], [sel_sq[1] + 1, 7].min]
        when " "
          if !board.selected_piece
            potential_sel = board.square(sel_sq)
            board.selected_piece = potential_sel if potential_sel &&
              !potential_sel.valid_moves.empty? &&
              potential_sel.color == @board.player_turn
          elsif sel_sq == board.selected_piece.pos
            board.selected_piece = nil
          else
            turn_over = true if board.selected_piece.make_move(sel_sq)
          end
        when "\e"
          exit
        end
        # board.display_board(true)
      end
    rescue ChessError => e
      puts "here now"
    end

    if @board.game_over?
      sleep(2)
      @board.win
    end
    nil
  end
end
