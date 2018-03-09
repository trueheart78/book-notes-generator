require_relative 'test_helper'
require 'chapter'
require 'ostruct'

class ChapterAsAppendixTest < Minitest::Test
  include TestHelper

  def subject
    @subject ||= Chapter.new(mock_chapter.num, mock_chapter.name, appendix: true, zero_based: true)
  end

  def test_to_s
    output = capture_output { print subject }
    assert_equal(mock_chapter.string, output)
  end

  def test_file_name
    assert_equal(mock_chapter.file_name, subject.file_name)
  end

  def test_readme_md
    assert_equal(mock_chapter.readme, subject.readme_md)
  end

  def test_to_md
    assert_match(/\[&lt;&lt; Back to the README\]\[readme\]/, subject.to_md)
    assert_match(/#{mock_chapter.proper_name}/, subject.to_md)
    assert_match(/_Notes_/, subject.to_md)
  end

  def notes_match
    /\*Notes forthcoming\*/
  end

  def mock_chapter
    @mock_chapter ||= OpenStruct.new.tap do |c|
      c.name = 'The Ninth Appendix'
      c.name_as_file = 'the-ninth-appendix'
      c.num = 8
      c.num_str = '09'
      c.file_name = "ap#{c.num_str}-#{c.name_as_file}.md"
      c.proper_name = "Appendix #{c.num_str.to_i}. #{c.name}"
      c.readme = "[#{c.proper_name}](#{c.file_name})"
      c.string = "#{c.num_str}. #{c.name} - #{c.file_name}"
    end
  end
end
