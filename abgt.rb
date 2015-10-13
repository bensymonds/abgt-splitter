require 'optparse'
require_relative 'lib/splitter'
require_relative 'lib/tagger'
require_relative 'lib/copier'

options = {}
OptionParser.new do |opts|
  opts.on("-l") do |v|
    options[:list] = v
  end
  opts.on("-s") do |v|
    options[:split] = v
  end
  opts.on("-t") do |v|
    options[:tag] = v
  end
  opts.on("-c") do |v|
    options[:copy] = v
  end
  opts.on("-a") do |v|
    options[:all] = v
  end
end.parse!

if options[:all]
  options[:split] = true
  options[:tag] = true
  options[:copy] = true
end

if options[:list]
  Tagger.new(".").list
  return
end

if options[:split]
  files = Dir.glob('ABGT*.mp3').select do |fn|
    fn =~ Splitter::FILE_REGEXP
  end
  dirnames = Splitter.split(files)
  File.delete(*files)
end

Tagger.tag(dirnames) if options[:tag]
Copier.copy(dirnames) if options[:copy]
