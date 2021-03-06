# frozen_string_literal: true

require 'config'

class FileSystem
  attr_reader :errors, :file

  def initialize(file, config)
    @errors = []
    @file = file
    @config = config
  end

  def validate
    validate_file
    display_errors if errors.any?
  end

  def validate!
    validate
    exit 1 if errors.any?
  end

  def yaml_file_path
    File.join config.yaml_path, file
  end

  private

  def valid?
    errors.size.zero?
  end

  def display_errors
    errors.each do |e|
      puts "Error: #{e[:message]}"
    end
  end

  def validate_file
    raise 'Method not implemented'
  end

  attr_reader :config
end
