# frozen_string_literal: true

require 'optparse'

class Options
  attr_accessor :continue
  attr_reader :filename

  def initialize
    self.continue = true
    @filename = ''
  end

  def parse!
    self.filename = ARGV.last.downcase unless ARGV.last.nil?
    OptionParser.new do |opts|
      opts.banner = "Usage: generate [options] filename\n"

      opts.on('-h', '--help', 'Displays help') do
        self.continue = false
        puts opts
      end

      self.continue = false if ARGV.count.zero? || !file?

      puts opts unless continue?
    end.parse!
  end

  def filename=(name)
    return unless name

    if File.extname(name) == '.yml'
      @filename = name
    else
      @filename = name.delete('!*&#?:;').tr('_ ', '-')
      @filename << '.yml'
    end
  end

  def file?
    !filename.nil?
  end

  def continue?
    continue
  end
end
