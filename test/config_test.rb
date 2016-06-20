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
    assert_equal(Pathname.new('tmp'), subject.base_path)
  end

  def test_yaml_path
    assert_equal(Pathname.new('tmp/_yaml_'), subject.yaml_path)
  end

  def test_notes_path
    assert_equal(Pathname.new('tmp/notes'), subject.notes_path)
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

  def test_compose_notes_dir
    assert_equal Pathname.new('notes/book-dir'), subject.compose_notes_dir('book-dir')
  end

  def test_compose_notes_dir_when_nil
    config_path = fixture_config_path empty_notes_config_file
    empty_notes_config = Config.new config_path: config_path
    assert_equal Pathname.new('book-dir'), empty_notes_config.compose_notes_dir('book-dir')
  end

  def test_relative_path
    assert_equal Pathname.new('..'), subject.relative_path
  end

  def invalid_config_path
    Pathname.new 'bad/config/path'
  end

  def empty_notes_config_file
    Pathname.new 'config-sans-notes-dir'
  end
end
