require 'yaml'

class Config
  def self.load
    @yaml_data = YAML.load_file(config_file)
  end

  private

  def config_file
    'config.default'
  end
end
