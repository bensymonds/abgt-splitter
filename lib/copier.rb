require 'fileutils'

class Copier
  DEST = File.join(Dir.home, 'Dropbox', 'Music')

  def self.copy(dirnames)
    dirnames.each do |dn|
      Copier.new(dn).copy!
    end
  end

  attr_reader :dirname

  def initialize(dirname)
    @dirname = dirname
  end

  def copy!
    puts "Copying #{dirname}"
    FileUtils.mv(dirname, DEST)
  end
end
