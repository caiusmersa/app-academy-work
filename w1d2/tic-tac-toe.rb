class Game
  attr_reader :player1, :player2
  attr_reader :board

  def initialize(player1, player2)
    @player1 = player1
    @player2 = player2
    @board = Board.new
  end

  def play!
    until board.won? || board.count == 9
      player1_moved = false
      until player1_moved
        board.display unless player1.ai?
        player1_moved = board.place_mark(player1.get_move, :X, player1.ai?)
        break if board.won? || board.count == 9
      end
      player2_moved = false
      until player2_moved || board.count == 9
        board.display unless player2.ai?
        player2_moved = board.place_mark(player2.get_move, :O, player2.ai?)
      end
    end
    board.display
    puts board.won? ? "Player #{board.winner}, you won!" : "Sorry, you all lose."
    board.winner
  end
end

class Board
  attr_reader :grid
  attr_accessor :winner, :count

  def initialize
    @grid = Array.new(3) { Array.new(3) {" "} }
    @winner = nil
    @count = 0
  end

  def display
    grid.each_with_index do |row, idx|
       puts "  #{idx} | #{row[0]} | #{row[1]} | #{row[2]} |"
    end
    puts "    |____________|"
    puts "    | 0 | 1 | 2 |"
    #grid.each {|row| p row}
  end

  def [](row, col)
    grid[row][col]
  end

  def []=(row, col, mark)
    grid[row][col] = mark
  end

  def switch_rows_to_columns
    result = Array.new(grid.count) { [] }
    grid.each_with_index do |row, i|
      row.each_with_index do |n, l|
        result[l][i] = n
      end
    end
    result
  end

  def three_in_a_row?(current_grid)
    current_grid.each do |row|
      if row[0] != " " && row[0] == row[1] && row[0] == row[2]
        self.winner = row[0]
        return true
      end
    end
    false
  end

  def three_in_a_row_diagonals?
    if   self.[](1,1) != " " &&
      ( (self.[](1,1) == self.[](0,2) && self.[](1,1) == self.[](2,0)) ||
        (self.[](1,1) == self.[](0,0) && self.[](1,1) == self.[](2,2)) )
      self.winner = self.[](1,1)
      return true
    end
    false
  end

  def won?
    three_in_a_row?(grid) || three_in_a_row?(switch_rows_to_columns) || three_in_a_row_diagonals?
  end

  def empty?(pos)
    grid[pos[0]][pos[1]] == " "
  end

  def place_mark(pos, mark, ai)
    if empty?(pos)
      grid[pos[0]][ pos[1]] = mark
      puts "Player #{mark} has made their mark on #{pos}!"
      self.count += 1
      true
    else
      puts "Your opponent's mark is already there! Tough Luck..." unless ai
      false
    end
  end
end

class HumanPlayer
  def get_move
    puts "Select a row!"
    row = Integer(gets)
    puts "Select a column!"
    column = Integer(gets)
    if (0..2).include?(row) && (0..2).include?(column)
      [row, column]
    else
      puts "Sorry, that's an invalid move."
      get_move
    end
  end

  def ai?
    false
  end
end

class ComputerPlayer
  def get_move
    row = (0..2).to_a.shuffle.first
    column = (0..2).to_a.shuffle.first
    [row, column]
  end

  def ai?
    true
  end
end

if __FILE__ == $PROGRAM_NAME
  print "How many human players? (0,2): "
  players = Integer(gets)
  case players
  when 0
    game = Game.new(ComputerPlayer.new, ComputerPlayer.new)
  when 1
    game = Game.new(HumanPlayer.new, ComputerPlayer.new)
  when 2
    game = Game.new(HumanPlayer.new, HumanPlayer.new)
  end
  game.play!
end
