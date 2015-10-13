require 'taglib'

class Tagger
  COMMON_TAGS = [
    :album,
    :artist,
    :comment,
    :genre,
    :title,
    :track,
    :year,
  ]

  GENRE = "Compilations"
  YEAR = 2014

  attr_reader :dirname

  def self.tag(dirnames)
    dirnames.each do |dn|
      Tagger.new(dn).tag!
    end
  end

  def initialize(dirname)
    @dirname = dirname
  end

  def filename(fn)
    File.join(dirname, fn)
  end

  def list
    Dir.entries(dirname).each do |fn|
      next unless fn =~ /.mp3$/

      puts "#" * 10 + ' ' + filename(fn)
      TagLib::MPEG::File.open(filename(fn)) do |file|
        if file.id3v2_tag
          file.id3v2_tag.frame_list.sort_by(&:frame_id).each do |f|
            puts "#{f.frame_id} : #{f.field_list}"
          end
          puts
        end
        COMMON_TAGS.each do |t|
          puts "#{t}: #{file.tag.send(t)}"
        end
      end
    end
  end

  SEP = '\s-\s'
  R = /
    (?<album>.+)
    #{SEP}
    (?<track>.+)
    #{SEP}
    (?<artist>.+)
    #{SEP}
    (?<title>.+)
    \.mp3
  /xi

  def tag!
    puts "Tagging #{dirname}"
    Dir.entries(dirname).each do |fn|
      next unless fn =~ /.mp3$/

      m = R.match(fn)
      TagLib::FileRef.open(filename(fn)) do |file|
        fail fn unless file.tag.empty?

        file.tag.album = m[:album]
        file.tag.track = m[:track].to_i
        file.tag.artist = m[:artist]
        file.tag.title = m[:title]

        file.tag.genre = GENRE
        file.tag.year = YEAR

        file.save
      end
    end
  end
end
