require_relative 'test_helper'
require 'config'

class ConfigTest < Minitest::Test
  include TestHelper

  def subject
    @subject ||= Config.new config_path: test_config_path
  end

  def teardown
    @subject = nil
  end

  def test_base_path
    assert_equal('tmp', subject.base_path)
  end

  def test_yaml_path
    assert_equal('tmp/_yaml_', subject.yaml_path)
  end

  def test_notes_path
    assert_equal('tmp/notes', subject.notes_path)
  end

  def test_valid
    assert subject.valid?
  end

  def test_valid_alone
    known_good_config = Config.new config_path: test_config_path
    assert known_good_config.valid?
  end

  def test_invalid
    bad_config = Config.new config_path: invalid_config_path
    refute bad_config.valid?
  end

  def test_missing_config_file
    bad_config = Config.new config_path: invalid_config_path
    capture_output{ bad_config.base_path }
    refute bad_config.valid?
  end

  def invalid_config_path
    'bad/config/path'
  end
end
