require_relative 'node'
require 'pry-byebug'

class Tree
  def initialize(array = [])
    @root = build_tree(array.uniq.sort)
  end

  def build_tree(array)
    return nil if array.empty? # Base case: stop recursion

    mid = array.size / 2
    node = Node.new(array[mid])

    node.left = build_tree(array[0...mid]) # 0 to not included mid, ...
    node.right = build_tree(array[mid+1..])  # mid+1 include the end, ..

    node
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def insert(value, node = @root)
    return Node.new(value) if node.nil?

    if value < node.data
      node.left = insert(value, node.left)
    elsif value > node.data
      node.right = insert(value, node.right)
    end

    node
  end

  def delete
    
  end
end

tree = Tree.new([1, 3, 4, 5, 7])
tree.insert(2)
tree.pretty_print