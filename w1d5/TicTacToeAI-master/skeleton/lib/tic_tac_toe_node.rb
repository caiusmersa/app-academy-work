require_relative 'tic_tac_toe'

class TicTacToeNode
  attr_reader :prev_move_pos, :next_mover_mark, :board

  def initialize(board, next_mover_mark, prev_move_pos = nil)
    @board = board
    @next_mover_mark = next_mover_mark
    @prev_move_pos = prev_move_pos
  end

  def possible_moves
    moves = []
    @board.empty_positions.each do |pos|
      child_board = @board.dup
      child_board[pos] = @next_mover_mark
      moves << TicTacToeNode.new(child_board, opponent(@next_mover_mark), pos)
    end

    moves
  end

  def losing_node?(evaluator)
    return  @board.winner == opponent(evaluator) if @board.over?

    if @next_mover_mark == evaluator  #computer's turn
      possible_moves.all? { |move| move.losing_node?(evaluator) }
    else                             #human's turn
      possible_moves.any? { |move| move.losing_node?(evaluator) }
    end
  end

  def winning_node?(evaluator)
    return @board.winner == evaluator if @board.over?

    if @next_mover_mark == evaluator  #computer's turn
      possible_moves.any? { |move| move.winning_node?(evaluator) }
    else                             #human's turn
      possible_moves.all? { |move| move.winning_node?(evaluator) }
    end
  end

  private
  def opponent(mark)
    mark == :x ? :o : :x
  end
end
