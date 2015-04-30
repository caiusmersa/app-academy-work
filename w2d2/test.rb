require_relative 'piece.rb'
require_relative 'board.rb'
require_relative 'player.rb'

require 'byebug'
require 'colorize'
require 'yaml'

load 'board.rb'
load 'piece.rb'
load 'player.rb'

if __FILE__ == $PROGRAM_NAME
  board = Board.new
  board.display_board
  # knight = board.square([0,1])
  # queen = board.square([0,3])
  # king = board.square([0,4])
  # rook = board.square([0, 0])
  # w_pawn1 = board.square([6,4])
  # b_pawn1 = board.square([1,4])
  # b_pawn2 = board.square([1,3])
  # b_pawn2.make_move([3,3])
  # duped = board.deep_dup
  # queen.make_move([2,3])
  # board.selected_piece = queen
  player = HumanPlayer.new(:B, board)
  player.get_move
  # puts "original:"
  # board.display_board
  # puts "duped: "
  # duped.display_board
end
