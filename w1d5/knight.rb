require './lib/00_tree_node.rb'

class KnightPathFinder

  def self.valid_moves(pos)
    x, y = pos[0], pos[1]
    possible_moves = [[x+2,y+1],[x+2,y-1],[x-2,y+1],[x-2,y-1],
                      [x+1,y+2],[x+1,y+2],[x-1,y-2],[x-1,y-2]]

    possible_moves.reject do |pos|
      pos[0] < 0 || pos[1] < 0 || pos[0] > 7 || pos[1] > 7
    end

    # possible_moves.select do |pos|
    #   pos.all? { |x| x.between?(0, 7) }
    # end
  end

  def initialize(start_pos)
    @start_pos = start_pos
    @visited_positions = [@start_pos]
  end

  def find_path(end_pos)
    build_move_tree.bfs(end_pos).trace_path_back
  end

  private

  def build_move_tree
    @visited_positions = [@start_pos]
    root = PolyTreeNode.new(@start_pos)
    queue = [root]
    do_queue_routine(queue) until queue.empty?

    root
  end

  def do_queue_routine(queue)
    current_node = queue.shift
    current_position = current_node.value
    moveable_positions = new_move_positions(current_position)
    moveable_nodes = PolyTreeNode.make_nodes(moveable_positions)
    current_node.add_children(moveable_nodes)
    queue.concat(moveable_nodes)

    queue
  end

  def new_move_positions(pos)
    new_move_pos = KnightPathFinder.valid_moves(pos) - @visited_positions
    @visited_positions += new_move_pos

    new_move_pos
  end
end
