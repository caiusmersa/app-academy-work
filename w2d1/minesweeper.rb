require 'set'
require 'byebug'
require 'colorize'

class Game
  def self.play!(size, num_mines)
    board = Board.new(size)
    board.seed_bombs(num_mines)
    puts "Welcome to Minesweeper (Color ASCII edition)".green

    until board.won? || board.lost?
      board.display

      action = Game.get_action
      coords = Game.get_coords(board)

      board[coords].flag if action ==  "f"
      board[coords].reveal if action == "r"
    end

    Game.game_over(board)

  end

  private
    def self.get_action
      begin
        print "\nWould you like to (".green
        print "f".red
        print ")lag/un(".green
        print "f".red
        print ")lag or (".green
        print "r".red
        puts ")eveal a square?".green
        action = $stdin.gets.chomp.downcase
        raise ArgumentError.new("Invalid action!") unless action == "f" || action == "r"
        puts "Alright, #{action == "f" ? "flag".red : "reveal".red} it is!".green

      rescue
        puts "Let's try that again...".red
        retry
      end
      action
    end

    def self.get_coords(board)
      begin
        print "Enter some coordinates, por favor(e.g. 3,5): ".green
        pos = $stdin.gets.chomp.split(",").map(&:to_i)
        raise ArgumentError.new("Invalid coords!") if pos.count != 2 || board[pos].nil?
      rescue
        puts "Let's try that again...".red
        retry
      end
      pos
    end

    def self.game_over(board)
      if board.won?
        puts "You won!! You're a good Minesweeper player and human being!".blue
      else
        puts "You lost! :(".red + "but you're still a good human being!".green
      end

      board.reveal_all
      board.display
    end

end

class Board

  def initialize(size)
    @size = size
    @tiles = Array.new(@size) { Array.new(@size) }
  end

  def seed_bombs(num_bombs)
    bomb_pos = Set.new
    until bomb_pos.count == num_bombs
      bomb_pos << [rand(@size), rand(@size)]
    end

    (0...@size).each do |row|
      (0...@size).each do |col|
        @tiles[row][col] =
          Tile.new(self, [row, col], bomb_pos.include?([row, col]))
      end
    end
  end

  def [](pos)
    return nil if pos.any? { |coord| coord < 0 || coord >= @size }
    row, col = pos[0], pos[1]
    @tiles[row][col]
  end

  def display
    @tiles.each_with_index do |row, row_idx|
      print "#{row_idx < 10 ? " " + row_idx.to_s.green : row_idx.to_s.green} | "

      row.each do |cell|
        print " " + cell.inspect + " "
      end
      print "\n"
    end

    (@size*3+5).times { print "_" }
    print "\n    "
    (0...@size).each { |idx| print " #{idx < 10 ? " " + idx.to_s.green : idx.to_s.green}" }
    print "\n"
  end

  def reveal_all
    each_tile { |tile| tile.reveal! }
  end

  def lost?
    each_tile { |tile| return true if tile.revealed? && tile.bombed? }
    false
  end

  def won?
    each_tile { |tile| return false unless tile.revealed? || tile.bombed? }
    true
  end

  private
    def each_tile(&prc)
      @tiles.each do |row|
        row.each do |tile|
          prc.call(tile)
        end
      end
    end
end


class Tile

  def initialize(board, pos, bombed)
    @board = board
    @pos = pos
    @revealed = false
    @flagged = false
    @bombed = bombed
  end

  def flag
    @flagged = !@flagged unless @revealed
  end

  def flagged?
    @flagged
  end

  def bombed?
    @bombed
  end

  def revealed?
    @revealed
  end

  def inspect
    if @revealed
      if @bombed
        "X".red
      else
        bombs = neighbor_bomb_count
        bombs == 0 ? "_".blue : bombs.to_s.yellow
      end
    else
      if @flagged
        "F".red
      else
        "*".blue
      end
    end
  end

  def neighbors
    neighbors = []
    (-1..1).each do |d_row|
      (-1..1).each do |d_col|
        next if d_row == 0 && d_col == 0

        tile = @board[[@pos.first + d_row, @pos.last + d_col]]
        neighbors << tile unless tile.nil?
      end
    end

    neighbors
  end

  def mystery_neighbors
    neighbors.reject { |neighbor| neighbor.revealed? }
  end

  def neighbor_bomb_count
    bombs = 0
    neighbors.each { |neighbor| bombs += 1 if neighbor.bombed? }

    bombs
  end

  def reveal
    return if flagged?
    @revealed = true

    if !bombed? && neighbor_bomb_count == 0
      mystery_neighbors.each { |neighbor| neighbor.reveal unless neighbor.bombed? }
    end
  end

  def reveal!
    @revealed = true
  end
end

if __FILE__ == $PROGRAM_NAME
  size = ARGV[0].nil? ? 8 : ARGV.shift.to_i
  mines = ARGV[0].nil? ? 11 : ARGV.shift.to_i

  Game.play!(size, mines)
end
