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
    diagonals_1 = [[pos.row + D_ROW[color],     pos.col + 1]
                   [pos.row + D_ROW[color],     pos.col - 1]]
    diagonals_2 = [[pos.row + D_ROW[color] * 2, pos.col + 2]
                   [pos.row + D_ROW[color] * 2, pos.col - 2]]

    diagonals_1.each do |simple_move|
      moves << simple_move if simple_move.on?(board)
  end

  def get_king_moves
end