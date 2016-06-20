require 'yaml'
require 'pathname'

class Config
  def initialize(config_path: nil)
    @use_config_path = config_path if config_path
  end

  def base_path
    load_yaml
    Pathname.new yaml_data['book_notes_path'] if valid?
  end

  def yaml_path
    @yaml_path ||= generate_path 'yaml_directory'
  end

  def notes_path
    @notes_path ||= generate_path 'notes_directory'
  end

  def relative_path
    base_path.relative_path_from notes_path
  end

  def valid?
    load_yaml
    @valid
  end

  def compose_notes_dir(book_directory)
    load_yaml
    dir = []
    dir << yaml_data['notes_directory'] if yaml_data['notes_directory']
    dir << book_directory
    File.join dir
  end

  private

  attr_reader :use_config_path, :yaml_data

  def generate_path(config_key)
    return base_path.join(yaml_data[config_key])
    #return base_path.join(yaml_data[config_key]) if yaml_data[config_key]
    base_path
  end

  def config_file
    return use_config_path if use_config_path
    return ENV['CONFIG_PATH'] if ENV['CONFIG_PATH']
    return 'config.default' unless ENV['NODE_ENV']
    return 'config.local' if local_supported?
    "config.#{ENV['NODE_ENV'].downcase}"
  end

  def local_supported?
    ENV['NODE_ENV'] == 'development' && File.exist?('config.local')
  end

  def load_yaml
    @yaml_data ||= YAML.load_file config_file
    @valid = true
  rescue Errno::ENOENT
    @valid = false
  end
end
