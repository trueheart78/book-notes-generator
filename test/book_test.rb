require_relative 'test_helper'
require 'book'

class BookTest < Minitest::Test
  include TestHelper

  def subject
    @subject ||= Book.new book_path, test_config
  end

  def test_missing_image_file
    fixture_path = fixture_book_path 'book-valid-no-image'
    subject_wo_image = Book.new fixture_path, test_config
    refute subject_wo_image.image.valid?
  end

  def test_directory
    assert_equal Pathname.new("#{test_config.notes_path}/an-awesome-book"), subject.directory
  end

  def test_relative_directory
    assert_equal Pathname.new('notes/an-awesome-book'), subject.relative_directory
  end

  def test_chapter_list
    assert_equal 4, subject.chapter_list.size
  end

  def test_chapter_length
    assert_equal 4, subject.chapter_length
  end

  def test_overview
    assert_match(/- Directory: #{subject.relative_directory}/, subject.overview)
    assert_match(/- Path: #{subject.directory}/, subject.overview)
    assert_match(/- Title: #{subject.title}/, subject.overview)
    assert_match(/- Year: #{subject.year}/, subject.overview)
    assert_match(/- Purchase: #{subject.purchase}/, subject.overview)
    assert_match(/- Author: #{subject.author}/, subject.overview)
    assert_match(/- Homepage: #{subject.homepage}/, subject.overview)
    assert_match(/- Image\? #{subject.image.valid?} \[#{subject.image.ext}\]/, subject.overview)
    assert_match(/#{subject.image.url}/, subject.overview)
  end

  def test_to_md
    assert_match(/\[🔙 🏡\]\(\.\.\/README.md\)/, subject.to_md)
    assert_match(/#{subject.title} \(#{subject.year}\)/, subject.to_md)
    assert_match(/#{subject.purchase}/, subject.to_md)
    assert_match(/#{subject.author}/, subject.to_md)
    assert_match(/#{subject.homepage}/, subject.to_md)
    assert_match(/!\[book cover\]\(cover.jpg\)/, subject.to_md)
  end

  def test_to_s
    assert_equal "'An Awesome Book (2018)' by That One Girl :: 4 chapters", subject.to_s
  end

  def test_public_yaml_interface
    yaml_fields.each do |field|
      assert subject.respond_to?(field)
    end
  end

  def test_sections_load
    assert_equal 1, subject.sections.size
  end

  def test_multiple_sections
    fixture_path = fixture_book_path 'book-valid-w-sections'
    subject_w_sections = Book.new fixture_path, test_config
    assert_equal 4, subject_w_sections.sections.size
    assert_match(/Appendices/, subject_w_sections.to_md)
  end

  def test_appendices
    fixture_path = fixture_book_path 'book-valid-w-appendices'
    subject_w_appendices = Book.new fixture_path, test_config
    assert_equal 2, subject_w_appendices.sections.size
  end

  def yaml_fields
    [:title, :purchase, :author, :homepage, :image, :image_ext, :sections]
  end
end
