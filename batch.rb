require 'optparse'
require 'fileutils'

Dir[File.dirname(__FILE__) + '/lib/*'].each { |file| require_relative file }

output_dir = nil
banner = 'Usage: ruby batch.rb [taxonomy-file-path destinations-file-path] [-o output-directory-path]'

opt_parser = OptionParser.new do |opts|
  opts.banner = banner
  opts.on('-out', '--output-dir OUTPUT', 'Output directory required.') do |opt|
    output_dir = opt.to_s
  end
end.parse!

taxonomies, destinations = ARGV

unless taxonomies && destinations && output_dir
  puts banner
  puts 'Please input taxonomies/destinations xml files and output directory.'
  exit
end

unless File.exist?(taxonomies) && File.exist?(destinations)
  puts 'Cannot find input files.'
  exit
end

unless File.directory?(output_dir) && File.writable?(output_dir)
  puts 'Directory must exist with writable permissions.'
  exit
end

FileUtils.cp('template/all.css', "#{output_dir}/all.css")

start_time = Time.now
node = Node.parse(File.read(taxonomies))

File.open(destinations) do |dest|
  Ox.sax_parse(Destination.new(node, output_dir), dest)
end

puts "Finished in #{Time.now - start_time} seconds"
