# frozen_string_literal: true

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
    node.right = build_tree(array[mid + 1..]) # mid+1 include the end, ..

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

  def delete(value, node = @root)
    return nil if node.nil?

    # Traverse Node
    if value < node.data
      node.left = delete(value, node.left)
    elsif value > node.data
      node.right = delete(value, node.right)
    else
      # Case 1 & 2: Delete Node with 0 and 1 children
      if node.left.nil?
        temp = node.right
        node = nil
        return temp
      elsif node.right.nil?
        temp = node.left
        node = nil
        return temp
      end
      # Case 3: Delete Node with 2 children
      temp = find_min(node.right) # find the most left from its right child
      node.data = temp.data # change the node value
      node.right = delete(temp.data, node.right) # delete the most left and move the lefties up
    end

    node
  end

  def find_min(node)
    current = node
    current = current.left while current.left
    current
  end

  def find(value, node = @root)
    return nil if node.nil?

    if value < node.data
      find(value, node.left)
    elsif value > node.data
      find(value, node.right)
    else
      pretty_print(node)
    end
  end

  def level_order
    return [] unless @root

    queue = [@root]
    result = []
    # binding.pry

    until queue.empty?
      node = queue.shift
      if block_given?
        yield node
      else
        result << node.data
      end

      queue << node.left if node.left
      queue << node.right if node.right

    end

    result unless block_given? # if no block given, use p tree.level_order to see the array
  end

  def preorder(node = @root, result = [])
    return result if node.nil?

    result << node.data
    preorder(node.left, result)
    preorder(node.right, result)

    result
  end

  def inorder(node = @root, result = [])
    return result if node.nil?

    inorder(node.left, result)
    result << node.data
    inorder(node.right, result)

    result
  end

  def postorder(node = @root, result = [])
    return result if node.nil?

    postorder(node.left, result)
    postorder(node.right, result)
    result << node.data

    result
  end

  def height(value, node = @root)
    if value < node.data
      height(value, node.left)
    elsif value > node.data
      height(value, node.right)
    else
      count_height(node)
    end
  end

  def count_height(node)
    return -1 if node.nil?

    # binding.pry
    left_height = count_height(node.left) # until it reach nil, it will start with -1, then +1 each return call
    right_height = count_height(node.right)
    [left_height, right_height].max + 1 # 1 + the greater of the heights of the left and right subtrees
  end

  def depth(value, node = @root, current_depth = 0)
    return nil if node.nil?

    if value < node.data
      depth(value, node.left, current_depth + 1)
    elsif value > node.data
      depth(value, node.right, current_depth + 1)
    else
      current_depth
    end
  end

  def balanced?(node = @root)
    return true if node.nil?

    left_height = count_height(node.left)
    right_height = count_height(node.right)

    return true if (left_height - right_height).abs <= 1 && balanced?(node.left) && balanced?(node.right)

    false
  end

  def rebalance
    @root = build_tree(inorder)
  end
end
