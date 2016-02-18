require 'spec_helper'
require 'node'

RSpec.describe Node do
  let(:node) { Node.parse(File.read('spec/fixtures/taxonomy.xml')).nodes.first }

  context 'attribute' do
    specify { expect(node.atlas_id).to eq('355064') }
  end

  context 'element' do
    specify { expect(node.name).to eq('Africa') }
  end

  context 'elements' do
    specify { expect(node).to be_kind_of(Node) }
  end
end
