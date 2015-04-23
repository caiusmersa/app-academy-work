require 'byebug'

class Maze < Array

  def self.load_file(maze_file)
    maze_rows = File.readlines(maze_file).map(&:chomp).map(&:chars)
    maze = Maze.new(maze_rows.count, maze_rows.first.count)
    maze.map!.with_index {|row, idx| maze_rows[idx]}
    maze
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
