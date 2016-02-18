require 'erb'

class Template
  attr_reader :destination

  def initialize(attrs)
    @destination = attrs
    @template = File.read('./template/index.erb')
  end

  def render
    ERB.new(@template).result( binding )
  end
end
