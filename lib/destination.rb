require 'ox'

class Destination < ::Ox::Sax
  attr_accessor :attrs, :output_dir
  
  def initialize(node, output_dir = nil)
    @attrs = {}
    @node = node
    @output_dir = output_dir
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

  # traverse nodes and add super_nav/sub_nav as hash e.g {123 => 'Africa'}.
  def add_navigations(parent_node, child_nodes)
    child_nodes.each do |child_node|
      if child_node.atlas_id.to_s == @attrs[:atlas_id].to_s
        @attrs[:super_nav], @attrs[:sub_nav] = {}, {}
        @attrs[:super_nav][parent_node.atlas_id] = parent_node.name if parent_node
        child_node.nodes.map { |n| @attrs[:sub_nav][n.atlas_id] = n.name }
        break
      else
        add_navigations(child_node, child_node.nodes)
      end
    end
  end

  def generate_html
    if @output_dir
      File.open("#{@output_dir}/#{@attrs[:atlas_id]}.html", 'w') do |f|
        f.write(Template.new(@attrs).render)
      end
    end
  end
end
