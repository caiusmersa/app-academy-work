require_relative 'board.rb'
# require_relative 'pos_helper.rb'
require_relative 'player.rb'
require_relative 'game_input.rb'

class DraughtsGame
  attr_accessor :board, :players

  def initialize(player1, player2)
    @players = { :p1 => player1, :p2 => player2 }
    @board = Board.new(player1.name, player2.name)
    player1.board = board
    player2.board = Board
    board.set_up_new_game
  end

  def play_game
    until board.over?
      board.display
      players[board.move_turn].make_move
    end
  end

  #___________________________________________________________________
  private
end

if __FILE__ == $PROGRAM_NAME
  GameInput.new_game_from_menu.play_game
end