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
    assert_match(matches[:readme], subject.to_md)
    assert(subject.to_md.include?(mock_chapter.proper_name))
    assert_match(matches[:notes], subject.to_md)
    assert_match(matches[:readme_link], subject.to_md)
  end

  def test_to_md_with_params
    @test_subject = subject.to_md previous: previous, upcoming: upcoming
    matches.each do |_, match|
      assert_match(match, @test_subject)
    end
    assert(@test_subject.include?(mock_chapter.proper_name))
  end

  def test_to_md_without_previous
    @test_subject = subject.to_md upcoming: upcoming
    matches.each do |key, match|
      assert_match(match, @test_subject) unless key.to_s.start_with? 'previous'
      refute_match(match, @test_subject) if key.to_s.start_with? 'previous'
    end
    assert(@test_subject.include?(mock_chapter.proper_name))
  end

  def test_to_md_without_upcoming
    @test_subject = subject.to_md previous: previous
    matches.each do |key, match|
      assert_match(match, @test_subject) unless key.to_s.start_with? 'upcoming'
      refute_match(match, @test_subject) if key.to_s.start_with? 'upcoming'
    end
    assert(@test_subject.include?(mock_chapter.proper_name))
  end

  def matches
    {
      notes: /_Notes_/,
      readme: /\[🏡\]\[readme\]/,
      previous: /\[🔙 Chapter 24. X\]\[previous-chapter\]/,
      upcoming: /\[Chapter 26. Z 🔜\]\[upcoming-chapter\]/,
      readme_link: /\[readme\]: README\.md/,
      previous_link: /\[previous-chapter\]: chapter-24-x\.md/,
      upcoming_link: /\[upcoming-chapter\]: chapter-26-z\.md/
    }
  end

  def previous
    @previous ||= { name: 'Chapter 24. X', file_name: 'chapter-24-x.md' }
  end

  def upcoming
    @upcoming ||= { name: 'Chapter 26. Z', file_name: 'chapter-26-z.md' }
  end

  def mock_chapter
    @mock_chapter ||= OpenStruct.new.tap do |c|
      c.name = 'The Chapter of Nine (Plus)'
      c.name_as_file = 'the-chapter-of-nine-plus'
      c.num = 8
      c.num_str = '09'
      c.file_name = "ch#{c.num_str}-#{c.name_as_file}.md"
      c.proper_name = "Chapter #{c.num_str.to_i}. #{c.name}"
      c.readme = "[#{c.proper_name}](#{c.file_name})"
      c.string = "#{c.num_str}. #{c.name} - #{c.file_name}"
    end
  end
end
