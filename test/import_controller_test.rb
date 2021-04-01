require_relative 'test_helper'
require 'import_controller'
require 'options'

class ImportControllerTest < Minitest::Test
  include TestHelper
  include FileSystemTestMixin

  def test_untested
    # p test_options.filename
    # p subject.yaml_file_path
    assert true
  end

  def subject
    ImportController.new test_options, test_config
  end

  def setup
    init_temp_dir
  end

  def teardown
    destroy_temp_dir
  end
end
