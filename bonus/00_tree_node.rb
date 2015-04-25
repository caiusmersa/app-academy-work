require 'byebug'

class PolyTreeNode
  attr_reader :parent, :children
  attr_accessor :value

  def self.make_nodes(values_array)
    values_array.map { |value| PolyTreeNode.new(value) }
  end

  def initialize(value)
    @value = value
    @parent = nil
    @children = []
  end

  def parent=(new_parent)
    parent.children.delete(self) unless parent.nil?
    @parent = new_parent
    parent.children << self unless parent.nil?
  end

  def add_child(child_node)
    # children << child_node
    child_node.parent = self
  end

  def add_children(children_array)
    children_array.each { |child| add_child(child) }
  end

  def remove_child(child)
    raise "node is not a child" if !@children.include?(child)
    # @children.delete(child)
    child.parent = nil
  end

  def node_count
    cnt = 0
    children.each { |child| cnt += child.node_count }
    cnt + 1
  end

  def dfs(target_value)
    return self if @value == target_value

    @children.each do |child|
      found_node = child.dfs(target_value)
      return found_node if found_node
    end

    nil
  end

  def bfs(target_value)
    queue = [self]
    until queue.empty?
      check_node = queue.shift
      return check_node if check_node.value == target_value
      queue += check_node.children
    end

    nil
  end

  def trace_path_back
     path = []
     node = self
     until node.nil?
       path << node.value
       node = node.parent
     end
     path
  end

  
end
