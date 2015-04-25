require_relative 'tic_tac_toe_node'

class SuperComputerPlayer < ComputerPlayer
  def move(game, mark)
    board = game.board
    root = TicTacToeNode.new(board, mark)
    moves = root.possible_moves
    move = moves.select { |move| move.winning_node?(mark) }.sample ||
           moves.select { |move| !move.losing_node?(mark) }.sample

    raise "Fuck this, I'm a perfect AI." if move.nil?
    move.prev_move_pos
  end
end

if __FILE__ == $PROGRAM_NAME
  puts "Play the brilliant computer!"
  hp = HumanPlayer.new("Jeff")
  cp = SuperComputerPlayer.new

  TicTacToe.new(hp, cp).run
end
