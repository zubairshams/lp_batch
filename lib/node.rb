require 'sax-machine'

class Node
  include SAXMachine

  attribute :atlas_node_id, as: :atlas_id
  element   :node_name,     as: :name
  elements  :node,          as: :nodes, class: Node
end
