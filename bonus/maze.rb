require 'byebug'
require 'colorize'

require './tree_node.rb'

  class Maze < Array

  def self.load_file(maze_file)
    maze_rows = File.readlines(maze_file).map(&:chomp).map(&:chars)
    maze = Maze.new(maze_rows.count, maze_rows.first.count)
    maze.each_index{ |idx| maze[idx] = maze_rows[idx] }
  end

  def initialize(num_rows, num_cols)
    super(num_rows) { Array.new(num_cols) }
  end

  def copy
    maze_copy = Maze.new(row_count, column_count)
    each_with_index { |row, row_num| maze_copy[row_num] = row.dup }

    maze_copy
  end

  def display
    each do |row|
      row.each do |char|
        case char
        when "*", "+", "|"
          print char.blue
        when "-"
          print char.cyan
        when "S", "E"
          print char.red
        when "."
          print char.yellow
        else
          print char
        end
      end
      print "\n"
    end
  end

  def in_bounds?(pos)
    pos.first >= 0 && pos.first < row_count &&
    pos.last  >= 0 && pos.last  < column_count
  end

  def moveable?(pos)
    in_bounds?(pos) &&
    (val(pos) == " " || val(pos) == "E")
  end

  def val(pos)
    self.fetch(pos.first)[pos.last]
  end

  def set_val(pos, val)
    self.fetch(pos.first)[pos.last] = val
  end

  def row(num_row)
    fetch(num_row)
  end

  def row_count
    count
  end

  def column_count
    first.count
  end
end

class MazeSolver

  attr_reader :maze

  def initialize(maze)
    @maze = maze
  end

  def solve
    start_time = Time.now

    path = build_move_tree.breadth_search(find_end).trace_path_back
    maze_copy = maze.copy
    path.each { |pos| maze_copy.set_val(pos, ".") }
    maze_copy.set_val(find_start, "S")
    maze_copy.set_val(find_end, "E")
    maze_copy.display

    puts "Solved in #{((Time.now - start_time) * 1000).to_i} miliseconds.".green
  end

  private

  def build_move_tree
    start_pos = find_start
    visited_pos = [find_start]
    root = PolyTreeNode.new(start_pos)
    queue = [root]
    do_build_move_tree_queue_routine(queue, visited_pos) until queue.empty?

    root
  end

  def do_build_move_tree_queue_routine(queue, visited_pos)
    current_node = queue.shift
    current_pos = current_node.value
    moveable_pos = valid_moves(current_pos).reject do |move|
      visited_pos.include?(move)
    end
    visited_pos.concat(moveable_pos)
    moveable_nodes = PolyTreeNode.make_nodes(moveable_pos)
    current_node.add_children(moveable_nodes)
    queue.concat(moveable_nodes)
  end

  def find_end
    find_val_in_maze("E")
  end

  def find_start
    find_val_in_maze("S")
  end

  def find_val_in_maze(val)
    row = maze.find_index { |row| row.include?(val) }
    col = maze.fetch(row).index(val)

    [row,col]
  end

  def valid_moves(pos)
    x, y = pos.first, pos.last
    potential_moves = [ [x, y + 1],[x, y - 1],
                        [x + 1, y],[x - 1,  y] ]

    potential_moves.select { |move| maze.moveable?(move) }
  end
end

if __FILE__ == $PROGRAM_NAME
  maze_solver = MazeSolver.new(Maze.load_file(ARGV.first)).solve
end
