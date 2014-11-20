require 'thor'
require 'pry'

class LineCount < Thor

  desc 'count PATH', 'counts lines in file or directory'
  def count(path)
    puts count_directory_lines(path)
  end

  private
  def count_file_lines(filename)
    return IO.readlines(filename).length
  end

  def count_directory_lines(path)
    Dir.chdir(path)
    files, directories = Dir.glob('*').partition { |f| File.file?(f) }
    line_count = files.inject(0) { |count, f| count + count_file_lines(f) }
    if directories.empty?
      return line_count
    else
      return line_count + directories.inject(0) { |c, dir| c + count_directory_lines(dir) }
    end
  end

end

LineCount.default_task(:count)
LineCount.start(ARGV)
