require 'yaml'

class Config
  def self.base_path
    self.load
    @yaml_data['book_notes_path']
  end

  def self.yaml_path
    @yaml_path ||= self.generate_path 'yaml_directory'
  end

  def self.notes_path
    @notes_path ||= self.generate_path 'notes_directory'
  end

  private

  def self.generate_path(config_name)
    path = [self.base_path]
    path << @yaml_data[config_name] if @yaml_data[config_name]
    path.join '/'
  end

  def self.config_file
    return ENV['CONFIG_PATH'] if ENV['CONFIG_PATH']
    return 'config.default' unless ENV['NODE_ENV']
    "config.#{ENV['NODE_ENV'].downcase}"
  end

  def self.load
    @yaml_data = YAML.load_file self.config_file
  end
end
