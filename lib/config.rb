# frozen_string_literal: true

require 'yaml'
require 'pathname'

class Config
  def initialize(config_path: nil)
    @config_path = config_path
    @yaml_data = nil

    load_yaml
  end

  def base_path
    Pathname.new yaml_data['book_notes_path'] if valid?
  end

  def yaml_path
    @yaml_path ||= generate_path 'yaml_directory'
  end

  def notes_path
    @notes_path ||= generate_path 'notes_directory'
  end

  def relative_path
    # if the notes dir is nil, then we are only a single jump away
    # if the notes path is not nil, then we are n+1 jumps away
    @relative_path = Pathname.new '..'
    @relative_path.join(base_path.relative_path_from(notes_path)) if notes_directory?
    @relative_path
  end

  def valid?
    @valid
  end

  def compose_notes_dir(book_directory)
    dir = []
    dir << yaml_data['notes_directory'] if notes_directory?
    dir << book_directory
    Pathname.new File.join(dir)
  end

  private

  attr_reader :config_path, :yaml_data

  def use_config_path?
    return true if config_path

    false
  end

  def generate_path(config_key)
    return base_path.join(yaml_data[config_key]) if yaml_data[config_key]

    base_path
  end

  def config_file
    return config_path if use_config_path?
    return ENV['CONFIG_PATH'] if ENV['CONFIG_PATH']
    return default_config_file unless ENV['NODE_ENV']
    return local_config_file if local_supported?

    "config.#{ENV['NODE_ENV'].downcase}"
  end

  def default_config_file
    'config.default.yml'
  end

  def local_config_file
    'config.local.yml'
  end

  def local_supported?
    ENV['NODE_ENV'] == 'development' && File.exist?(local_config_file)
  end

  def load_yaml
    return if @yaml_data

    if File.exist? config_file
      @yaml_data = YAML.load_file config_file
      @valid = true
    else
      @valid = false
    end
  end

  def notes_directory?
    return false if yaml_data.nil?
    return true if yaml_data['notes_directory']
  end
end
