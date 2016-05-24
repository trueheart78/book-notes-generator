require 'yaml'

class Config
  def initialize(config_path: nil)
    @use_config_path = config_path if config_path
  end

  def base_path
    load_yaml
    yaml_data['book_notes_path'] if valid?
  end

  def yaml_path
    @yaml_path ||= generate_path 'yaml_directory'
  end

  def notes_path
    @notes_path ||= generate_path 'notes_directory'
  end

  def valid?
    load_yaml
    @valid
  end

  private

  def generate_path(config_name)
    path = [base_path]
    path << yaml_data[config_name] if yaml_data[config_name]
    path.join '/'
  end

  def config_file
    return use_config_path if use_config_path
    return ENV['CONFIG_PATH'] if ENV['CONFIG_PATH']
    return 'config.default' unless ENV['NODE_ENV']
    "config.#{ENV['NODE_ENV'].downcase}"
  end

  def load_yaml
    @yaml_data ||= YAML.load_file config_file
    @valid = true
  rescue Errno::ENOENT
    @valid = false
  end

  def yaml_data
    @yaml_data
  end

  def use_config_path
    @use_config_path
  end
end
