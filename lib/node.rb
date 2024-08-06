class Node
  include Comparable

  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end

  attr_accessor :data, :left, :right

  def <=>(other)
    data <=> other
  end
end
