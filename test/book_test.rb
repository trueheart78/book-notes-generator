require_relative 'test_helper'
require 'book'

class BookTest < Minitest::Test
  include TestHelper

  def subject
    @subject ||= Book.new book_path, test_config
  end

  def test_image_file
    assert subject.image?
    assert_equal 'cover.jpg', subject.image_file
  end

  def test_missing_image_file
    fixture_path = fixture_book_path 'book-valid-no-image'
    subject_wo_image = Book.new fixture_path, test_config
    refute subject_wo_image.image?
    refute subject_wo_image.image
  end

  def test_directory
    assert_equal "#{test_config.notes_path}/an-awesome-book", subject.directory
  end

  def test_relative_directory
    assert_equal 'notes/an-awesome-book', subject.relative_directory
  end

  def test_chapter_length
    assert_equal 4, subject.chapter_length
  end

  def test_overview
    assert_match(/- Directory: #{subject.relative_directory}/, subject.overview)
    assert_match(/- Path: #{subject.directory}/, subject.overview)
    assert_match(/- Title: #{subject.title}/, subject.overview)
    assert_match(/- Purchase: #{subject.purchase}/, subject.overview)
    assert_match(/- Author: #{subject.author}/, subject.overview)
    assert_match(/- Homepage: #{subject.homepage}/, subject.overview)
    assert_match(/- Image\? #{subject.image?} \[#{subject.image_ext}\]/, subject.overview)
    assert_match(/#{subject.image}/, subject.overview)
  end

  def test_to_md
    assert_match(/\[&lt;&lt; Back to project home\]\(..\/..\/README.md\)/, subject.to_md)
    assert_match(/#{subject.title}/, subject.to_md)
    assert_match(/#{subject.purchase}/, subject.to_md)
    assert_match(/#{subject.author}/, subject.to_md)
    assert_match(/#{subject.homepage}/, subject.to_md)
    assert_match(/!\[book cover\]\(cover.jpg\)/, subject.to_md)
  end

  def test_to_s
    assert_equal "'An Awesome Book' by That One Girl :: 4 chapters", subject.to_s
  end

  def test_public_yaml_interface
    yaml_fields.each do |field|
      assert subject.respond_to?(field)
    end
  end

  def yaml_fields
    [:title, :purchase, :author, :homepage, :image, :image_ext, :chapters, :sections]
  end
end
