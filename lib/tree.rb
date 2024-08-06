require_relative 'node'

class Tree
  def initialize(array)
    @root = build_tree(array.sort.uniq)
  end

  attr_accessor :root

  def build_tree(array)
    if array.empty?
      return
    elsif array.length == 1
      new_node = Node.new(array[0])
    else
      quotient = array.length.divmod(2)[0]

      new_node = Node.new(array[quotient])

      new_node.left = build_tree(array[0, quotient])
      new_node.right = build_tree(array[(quotient + 1)..])
    end

    new_node
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def insert(value)
    current_node = root

    loop do
      if current_node > value
        if current_node.left.nil?
          current_node.left = Node.new(value)
          return
        end

        current_node = current_node.left
      else
        if current_node.right.nil?
          current_node.right = Node.new(value)
          return
        end

        current_node = current_node.right
      end
    end
  end

  def delete(value, root = self.root)
    return root if root.nil?

    if root > value
      root.left = delete(value, root.left)
    elsif root < value
      root.right = delete(value, root.right)
    elsif root.left.nil?
      return root.right
    elsif root.right.nil?
      return root.left
    else
      current_node = root.right

      current_node = current_node.left until current_node.nil? || current_node.left.nil?

      successor = current_node
      root.data = successor.data
      root.right = delete(successor.data, root.right)
    end

    root
  end

  def find(value)
    current_node = root

    until current_node.nil?
      if current_node == value
        return current_node
      elsif current_node > value
        current_node = current_node.left
      else
        current_node = current_node.right
      end
    end
  end

  def level_order(&block)
    return if root.nil?

    queue = []
    ordered_nodes = []

    queue << root

    until queue.empty?
      current = queue[0]
      ordered_nodes << current

      queue << current.left unless current.left.nil?
      queue << current.right unless current.right.nil?

      queue.shift
    end

    if block_given?
      ordered_nodes.each(&block)
    else
      ordered_nodes.map(&:data)
    end
  end

  def preorder(root = self.root, ordered_nodes = [], &block)
    return if root.nil?

    ordered_nodes << root

    left_node = preorder(root.left)
    right_node = preorder(root.right)

    ordered_nodes += left_node unless left_node.nil?
    ordered_nodes += right_node unless right_node.nil?

    if block_given?
      ordered_nodes.each(&block)
    elsif root == self.root
      ordered_nodes.map(&:data)
    else
      ordered_nodes
    end
  end

  def inorder(root = self.root, ordered_nodes = [], &block)
    return if root.nil?

    left_node = inorder(root.left)
    ordered_nodes += left_node unless left_node.nil?

    ordered_nodes << root

    right_node = inorder(root.right)
    ordered_nodes += right_node unless right_node.nil?

    if block_given?
      ordered_nodes.each(&block)
    elsif root == self.root
      ordered_nodes.map(&:data)
    else
      ordered_nodes
    end
  end

  def postorder(root = self.root, ordered_nodes = [], &block)
    return if root.nil?

    left_node = postorder(root.left)
    ordered_nodes += left_node unless left_node.nil?

    right_node = postorder(root.right)
    ordered_nodes += right_node unless right_node.nil?

    ordered_nodes << root

    if block_given?
      ordered_nodes.each(&block)
    elsif root == self.root
      ordered_nodes.map(&:data)
    else
      ordered_nodes
    end
  end

  def height(node)
    return 0 if node.nil? || (node.left.nil? && node.right.nil?)

    left_node_height = height(node.left)
    right_node_height = height(node.right)

    max_height = (left_node_height > right_node_height ? left_node_height : right_node_height)

    max_height + 1
  end

  def depth(node)
    return 0 if node == root

    current_node = root
    max_depth = 0

    until current_node.nil?
      if current_node == node.data
        return max_depth
      elsif current_node > node.data
        current_node = current_node.left
      else
        current_node = current_node.right
      end

      max_depth += 1
    end
  end

  def balanced?(node = root)
    return [true, -1] if node.nil?

    left_balanced, left_height = balanced?(node.left)
    right_balanced, right_height = balanced?(node.right)

    current_balanced = left_balanced && right_balanced && (left_height - right_height).abs <= 1
    current_height = [left_height, right_height].max + 1

    if node == root
      current_balanced
    else
      [current_balanced, current_height]
    end
  end

  def rebalance
    new_array = inorder
    self.root = build_tree(new_array.sort.uniq)
  end
end
