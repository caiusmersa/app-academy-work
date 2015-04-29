require './piece.rb'
require './board.rb'

require 'byebug'
require 'colorize'
require 'yaml'

load 'board.rb'
load 'piece.rb'

if __FILE__ == $PROGRAM_NAME
  board = Board.new
  board.display_board
  knight = board.square([0,1])
  queen = board.square([0,3])
  king = board.square([0,4])
  rook = board.square([0, 0])
  w_pawn1 = board.square([6,4])
  b_pawn1 = board.square([1,4])
  b_pawn2 = board.square([1,3])
  debugger
  i = 3
end
