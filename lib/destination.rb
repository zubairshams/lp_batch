require 'ox'

class Destination < ::Ox::Sax
  attr_reader :attrs
  
  def initialize(node)
    @attrs = {}
    @node = node
  end

  def start_element(name)
    # add overview key to the attr hash in order to extract overview cdata.
  	@attrs[name] = nil if name == :overview
  end

  def end_element(name)
    if name == :destination
      add_navigations(nil, @node.nodes)
      generate_html
    end
  end

  # adds only atlas_id/name to the attrs hash.
  def attr(name, value)
    case name
    when :atlas_id
      @attrs[:atlas_id] = value
    when :title
      @attrs[:name] = value
    end
  end

  # adds overview text.
  def cdata(value)
  	@attrs[:overview] = value.strip if @attrs.has_key?(:overview) && @attrs[:overview].nil?
  end

  # traverse nodes and add super_nav/sub_nav.
  def add_navigations(parent_node, child_nodes)
    child_nodes.each do |child_node|
      if child_node.atlas_id.to_s == @attrs[:atlas_id].to_s
        @attrs[:super_nav] = parent_node.nil? ? nil : parent_node.name
        @attrs[:sub_nav] = child_node.nodes.map { |n| n.name }
        break
      else
        add_navigations(child_node, child_node.nodes)
      end
    end
  end
end
