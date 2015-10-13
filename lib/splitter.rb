class Splitter
  START = { num: 99, time: Time.utc(2014, 10, 10) }
  SECONDS_IN_WEEK = 60 * 60 * 24 * 7
  MP3SPLIT = "mp3splt"
  FILE_REGEXP = /^ABGT(\d\d\d).mp3$/

  attr_reader :num, :part

  def self.split(filenames)
    filenames.map do |fn|
      new(fn).split
    end
  end

  def initialize(filename)
    fail unless (m = filename.match(FILE_REGEXP))
    @num = m[1].to_i
    @part = m[2].to_i if m[2]
  end

  def split
    system(mp3split_command)
    album_name
  end

  private

  def album_name
    s = 'Group Therapy ' +
        format("%03d", num) +
        ' (' +
        (START[:time] + ((num - START[:num]) * SECONDS_IN_WEEK)).strftime("%Y-%m-%d") +
        ')'
    s << " (Part #{part})" if part
    s
  end

  def mp3split_filename
    "#{album_name} - @n - @p - @t".tr(' ', '+')
  end

  def mp3split_command
    filename_root = "ABGT" + format("%03d", num)
    filename_root << "-#{part}" if part
    "#{MP3SPLIT} -f -n -d \"#{album_name}\" -o \"#{mp3split_filename}\" -c #{filename_root}.cue #{filename_root}.mp3"
  end
end
