require 'byebug'

class HanoiGame
  attr_accessor :board, :source_tower, :dest_tower

  def initialize(discs = 4)
    @complete_tower = (1..discs).to_a.reverse
    self.board = [@complete_tower.clone, [], [] ]
  end

  def play_game
    puts "Welcome to Tower of Hanoi!"
    while !check_win do
      display
      get_move
      if valid_move?
        make_move
      else
        puts "\n\n\n\n\nThat can't go there! Try again."
      end
    end

    display
    puts "Congrats! you won"
  end

  def get_move
    print "Please input the source tower: "
    self.source_tower = gets.strip.to_i
    print "\nPlease input the destination tower: "
    self.dest_tower = gets.strip.to_i
  end

  def valid_move?
    return false unless [0,1,2].include?(source_tower) &&
                        [0,1,2].include?(dest_tower)
    source_top = board[source_tower].last
    dest_top = board[dest_tower].last

    return false if source_top.nil?
    return true if dest_top.nil?

    source_top < dest_top
  end

  def make_move
    piece = board[source_tower].pop
    board[dest_tower].push(piece)
  end

  def display
    filler = " "
    puts "The current board is: "
    puts "
    | #{board[0][3] || filler} | #{board[1][3] || filler} | #{board[2][3] || filler} |
    | #{board[0][2] || filler} | #{board[1][2] || filler} | #{board[2][2] || filler} |
    | #{board[0][1] || filler} | #{board[1][1] || filler} | #{board[2][1] || filler} |
    | #{board[0][0] || filler} | #{board[1][0] || filler} | #{board[2][0] || filler} |
    |___|___|___|
    | 0 | 1 | 2 |
    "
  end

  def check_win
    board[2] == @complete_tower
  end
end

HanoiGame.new.play_game
