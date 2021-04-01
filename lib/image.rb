# frozen_string_literal: true

class Image
  attr_reader :url

  def initialize(url, ext)
    @url = url
    @ext = ext
  end

  def valid?
    return true if url && !url.empty? && ext && !ext.empty?
  end

  def ext
    @ext.strip.downcase
  end

  def file_name
    "cover.#{ext}"
  end

  def to_md
    return "![book cover](#{file_name})" if valid?

    ''
  end
end
