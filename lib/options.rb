require 'optparse'

class Options
  attr_accessor :filename, :continue

  def initialize
    self.continue = true
  end

  def parse!
    self.filename = ARGV.last
    OptionParser.new do |opts|
      opts.banner = "Usage: generate [options] filename\n"

      opts.on('-h','--help','Displays help') do
        self.continue = false
        puts opts
      end

      self.continue = false if ARGV.count == 0 || !self.file?

      puts opts unless self.continue?
    end.parse!
  end

  def file?
    !self.filename.nil?
  end

  def file
    return "#{filename}.yml" unless filename.downcase[-4..-1] == '.yml'
    filename
  end

  def continue?
    self.continue
  end
end
