require_relative 'test_helper'
require 'config'

class ConfigTest < Minitest::Test
  def test_base_path
    assert_equal('tmp', Config.base_path)
  end

  def test_yaml_path
    assert_equal('tmp/_yaml_', Config.yaml_path)
  end

  def test_notes_path
    assert_equal('tmp/notes', Config.notes_path)
  end
end
