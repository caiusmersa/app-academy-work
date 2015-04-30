require_relative 'pos_helper.rb'

class Piece
  attr_reader :color, :board, :pos, :is_king

  def initialize(color, board, pos, is_king = false)
    @color = color
    @board = board
    @pos = pos
    @is_king = is_king
  end

  def get_moves
  end

  #___________________________________________________________________
  private

  def get_pawn_moves
    moves = []
    diag_1 = [[pos.row + D_ROW[color],     pos.col + 1],
              [pos.row + D_ROW[color],     pos.col - 1]]
    diag_2 = [[pos.row + D_ROW[color] * 2, pos.col + 2],
              [pos.row + D_ROW[color] * 2, pos.col - 2]]

    diag_1.each do |simple_move|
      if simple_move.on?(board) && board.get(simple_move).nil?
        moves << simple_move
      end
    end

    diag_2.each_with_index do |capt_move, i|
      if capt_move.on?(board) && board.get(capt_move).nil? &&
         board.get(diag_1[i]) && board.get(diag_1[i]).color != color
         moves << capt_move
      end
    end

    moves
  end

  def get_king_moves
  end
end