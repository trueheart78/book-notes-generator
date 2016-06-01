require_relative 'test_helper'
require 'section'

class SectionTest < Minitest::Test
  include TestHelper

  def subject
    @subject ||= Section.new valid_name, chapter_list
  end

  def offset_subject
    @offset_subject ||= Section.new valid_name, chapter_list_offset, offset: offset
  end

  def test_name
    assert_equal valid_name, subject.name
    assert subject.name?
  end

  def test_chapter_length
    assert_equal chapter_list.size, subject.chapter_length
  end

  def test_invalid_name
    section = Section.new invalid_name, chapter_list
    refute section.name?
  end

  def test_create_from_chapters
    section = Section.create_from_chapters(chapter_list)
    refute section.name?
    assert_equal chapter_list.size, section.chapter_length
  end

  def test_to_md
    markdown = subject.to_md
    assert_match(/- \*\*#{valid_name}\*\*/, markdown)
    chapter_list.each do |chapter_name|
      assert_match(/\s\s- \[Chapter \d\. #{chapter_name}\]/, markdown)
    end
  end

  def test_to_md_offset
    markdown = offset_subject.to_md
    assert_match(/- \*\*#{valid_name}\*\*/, markdown)
    chapter_list_offset.each do |chapter_name|
      assert_match(/\s\s- \[Chapter \d+\. #{chapter_name}\]/, markdown)
    end
  end

  def test_to_md_nameless
    section = Section.create_from_chapters(chapter_list)
    markdown = section.to_md
    refute_match(/- \*\*\w+\*\*/, markdown)
    chapter_list.each do |chapter_name|
      assert_match(/- \[Chapter \d+\. #{chapter_name}\]/, markdown)
    end
  end

  def test_chapters
    assert_equal chapter_list.size, subject.chapters.size
  end

  def test_overview
    overview = subject.overview
    assert_match(/\s\s#{valid_name}/, overview)
    chapter_list.each do |chapter_name|
      assert_match(/\s\s\s\s\d+\. #{chapter_name}\s-\s.+\.md/, overview)
    end
  end

  def test_overview_nameless
    section = Section.create_from_chapters(chapter_list)
    overview = section.overview
    refute_match(/\s\s#{valid_name}/, overview)
    chapter_list.each do |chapter_name|
      assert_match(/\s\s\d+\. #{chapter_name}\s-\s.+\.md/, overview)
    end
  end


  def valid_name
    'test'
  end

  def invalid_name
    nil
  end

  def offset
    5
  end

  def chapter_list
    ['Intro', 'Middle Part', 'The End']
  end

  def chapter_list_offset
    1.upto(offset).each.map { |n| "#{(n+offset)} Great Words" }
  end
end
