require_relative 'lib/tree'

bst = Tree.new(Array.new(15) { rand(1..100) })

puts bst.balanced?

p bst.level_order
p bst.preorder
p bst.postorder
p bst.inorder

bst.insert(101)
bst.insert(102)
bst.insert(103)
bst.insert(104)
bst.insert(105)

puts bst.balanced?

bst.rebalance

puts bst.balanced?

p bst.level_order
p bst.preorder
p bst.postorder
p bst.inorder
