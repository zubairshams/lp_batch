require 'spec_helper'
require 'destination'

RSpec.describe Destination do
  let(:node) { Node.parse(File.read('spec/fixtures/taxonomy.xml')) }
  let(:destination) {Destination.new(node)}

  describe '#start_element' do
    context 'valid' do
      specify do
        destination.start_element(:overview)
        expect(destination.attrs).to have_key(:overview)
      end
    end

    context 'invalid' do
      specify do
        destination.start_element(:atlas_id)
        expect(destination.attrs).not_to have_key(:atlas_id)
      end
    end
  end

  describe '#end_element' do
    before do
      File.open('spec/fixtures/destinations.xml') do |f|
        Ox.sax_parse(destination, f)
      end
    end

    specify do
      expect(destination.attrs).to eq({
        atlas_id: '355064',
        name: 'Africa',
        overview: 'Africa Overview',
        super_nav: nil,
        sub_nav: ['South Africa']})
    end
  end

  describe '#attr' do
    context 'valid' do
      specify do
        destination.attr(:title, 'Africa')
        expect(destination.attrs[:name]).to eq('Africa')
      end
    end

    context 'invalid' do
      specify do
        destination.attr(:geo_id, '123')
        expect(destination.attrs[:geo_id]).to be_nil
      end
    end
  end

  describe '#cdata' do
    context 'valid' do
      specify do
        destination.start_element(:overview)
        destination.cdata('Africa Overview ')
        expect(destination.attrs[:overview]).to eq('Africa Overview')
      end
    end

    context 'invalid' do
      specify do
        destination.cdata('Africa Overview ')
        expect(destination.attrs[:overview]).to be_nil
      end
    end
  end

  describe '#add_navigations' do
    context 'valid' do
      specify do
        destination.attr(:atlas_id, '355611')
        destination.add_navigations(nil, node.nodes)
        expect(destination.attrs[:super_nav]).to eq('Africa')
        expect(destination.attrs[:sub_nav]).to eq(['Cape Town'])
      end
    end

    context 'invalid' do
      specify do
        destination.attr(:atlas_id, nil)
        destination.add_navigations(nil, node.nodes)
        expect(destination.attrs[:super_nav]).to be_nil
        expect(destination.attrs[:sub_nav]).to be_nil
      end
    end
  end
end
