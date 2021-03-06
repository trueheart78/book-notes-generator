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

    assert_path_exists(subject.yaml_file_path)
    assert_match(/File created: #{subject.yaml_file_path}/, output)
  end

  def test_error_on_existing_file
    suppress_output { subject.run }

    other_yaml_generator = YamlGenerator.new(sample_filename, test_config)
    error_string = capture_output { other_yaml_generator.run }

    assert_match(/Error: File exists \(#{sample_file_path}\)/, error_string)
  end

  def test_content
    assert_equal(expected_content, subject.to_s)
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
    File.join test_config.yaml_path, sample_filename
  end

  def expected_content
    <<~YAML
      ---
      :title:
      :year:
      :purchase:
      :author:
      :homepage:
      :image:
      :image_ext:

      :sections:
        -
          :name:
          :chapters:
          - chapter
        -
          :name: Section 1
          :chapters:
          - chapter
    YAML
  end
end
