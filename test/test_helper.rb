$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
ENV['NODE_ENV'] = 'test'
ENV['CONFIG_PATH'] = 'test/fixtures/config.test'

require 'fileutils'
require 'minitest/autorun'
require 'file_system_test_mixin'
require 'config'

module TestHelper
  def capture_output
    old_stdout = $stdout
    $stdout = StringIO.new '','w'
    yield
    $stdout.string
  ensure
    $stdout = old_stdout
  end
  alias :suppress_output :capture_output

  def book_path
    fixture_path('book-valid')
  end

  def fixture_path(fixture)
    ['test','fixtures',"#{fixture}.yml"].join '/'
  end

  def test_config_path
    'test/fixtures/config.test'
  end

  def test_config
    @test_config ||= Config.new config_path: test_config_path
  end

  def init_temp_dir
    FileUtils.mkdir_p test_config.yaml_path
    FileUtils.mkdir_p test_config.notes_path
  end

  def destroy_temp_dir
    FileUtils.rm_rf test_config.base_path
  end
end
