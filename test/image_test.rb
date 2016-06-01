require_relative 'test_helper'
require 'image'

class ImageTest < Minitest::Test
  include TestHelper

  def subject
    @subject ||= Image.new image_url, image_ext
  end

  def test_ext
    assert_equal image_ext, subject.ext
  end

  def test_file_name
    assert_equal "cover.#{image_ext}", subject.file_name
  end

  def test_to_md
    assert_equal "![book cover](cover.#{image_ext})", subject.to_md
  end

  def test_to_md_invalid
    bad_image = Image.new '', ''
    assert bad_image.to_md.empty?
  end

  def test_valid
    assert subject.valid?
  end

  def test_invalid
    bad_image = Image.new '', ''
    refute bad_image.valid?

    bad_image = Image.new image_url, ''
    refute bad_image.valid?

    bad_image = Image.new '', image_ext
    refute bad_image.valid?
  end

  def image_url
    'http://sample.url.com/image.jpg?12345'
  end

  def image_ext
    'jpg'
  end
end
