require 'byebug'
require '00_tree_node.rb'

class Maze < Array

  def self.load_file(maze_file)
    maze_rows = File.readlines(maze_file).map(&:chomp).map(&:chars)
    maze = Maze.new(maze_rows.count, maze_rows.first.count)
    maze.map!.with_index {|row, idx| maze_rows[idx]}
    maze
  end


  def valid_moves(pos)
    x,y = pos[0],pos[1]
    potential_moves = [[x+1,y+1],[x-1,y-1],[x+1,y-1],[x-1,x+1]]

    possible_moves = []
    potential_moves.each do |pos|
      possible_moves << pos valid?(pos)
    end

    possible_moves
  end

  def find_start
    row = self.find_index {|x| x.include?("S")}
    col = row.index("S")
    @start_pos = [row,col]
  end

  def valid?(pos)
    (val(pos) == " " || val(pos) == "E") &&
    (x < 0 || y < 0 || x >= width || y >= height)
  end




  def initialize(width, height)
    super(width) {Array.new(height)}
  end

  def [](x,y)
    at(x).at(y)
  end

  def []=(x,y,value)
    at(x).[]=(y, value)
  end

  def val(pos)
    self.[](pos[0], pos[1])
  end

  def rows
    count
  end

  def columns
    first.count
  end

  def width
    columns
  end

  def height
    rows
  end
end

if __FILE__ == $PROGRAM_NAME
  maze = Maze.load_file("maze.txt")
  p maze
end
