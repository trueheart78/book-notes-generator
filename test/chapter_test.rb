require_relative 'test_helper'
require 'chapter'
require 'ostruct'

class ChapterTest < Minitest::Test
  include TestHelper

  def subject
    @subject ||= Chapter.new(mock_chapter.num, mock_chapter.name, zero_based: true)
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

  def test_to_md_without_params
    assert_match(/\[&lt;&lt; Back to the README\]\(README.md\)/, subject.to_md)
    assert_match(/#{mock_chapter.proper_name}/, subject.to_md)
    assert_match(/\*Notes forthcoming\*/, subject.to_md)
  end

  def test_to_md_with_params
    @test_subject = subject.to_md previous: previous, upcoming: upcoming

    assert_match(previous_match, @test_subject)
    assert_match(upcoming_match, @test_subject)
    assert_match(readme_match, @test_subject)
    assert_match(/#{mock_chapter.proper_name}/, @test_subject)
    assert_match(/\*Notes forthcoming\*/, @test_subject)
  end

  def readme_match
    /\[README\]\(README.md\)/
  end

  def previous_match
    /\[&lt\;&lt\; Chapter 24. X\]\(chapter-24-x.md\)/
  end

  def upcoming_match
    /\[Chapter 26. Z &gt\;&gt\;\]\(chapter-26-z.md\)/
  end

  def previous
    @previous ||= { name: 'Chapter 24. X', file_name: 'chapter-24-x.md' }
  end

  def upcoming
    @upcoming ||= { name: 'Chapter 26. Z', file_name: 'chapter-26-z.md' }
  end

  def mock_chapter
    @mock_chapter ||= OpenStruct.new.tap do |c|
      c.name = 'The Chapter of Nine'
      c.name_as_file = 'the-chapter-of-nine'
      c.num = 8
      c.num_str = '09'
      c.file_name = "ch#{c.num_str}-#{c.name_as_file}.md"
      c.proper_name = "Chapter #{c.num_str.to_i}. #{c.name}"
      c.readme = "[#{c.proper_name}](#{c.file_name})"
      c.string = "#{c.num_str}. #{c.name} - #{c.file_name}"
    end
  end
end
