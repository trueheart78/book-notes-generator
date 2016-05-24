require_relative 'test_helper'
require 'yaml_generator'

class YamlGeneratorTest < Minitest::Test
  include TestHelper
  include FileSystemTestMixin

  def setup
    init_temp_dir
  end

  def test_writes_file
    output = capture_output { subject.run }

    assert File.exist? subject.yaml_file_path
    assert_match(/File created: #{subject.yaml_file_path}/, output)
  end

  def test_error_on_existing_file
    suppress_output { subject.run }

    other_yaml_generator = YamlGenerator.new(sample_filename, test_config)
    error_string = capture_output{ other_yaml_generator.run }

    assert_match(/Error: File exists \(#{sample_file_path}\)/, error_string)
  end

  def teardown
    destroy_temp_dir
  end

  def subject
    YamlGenerator.new(sample_filename, test_config)
  end

  def sample_filename
    'sample-xxx-book.yml'
  end

  def sample_file_path
    [test_config.yaml_path, sample_filename].join '/'
  end
end
