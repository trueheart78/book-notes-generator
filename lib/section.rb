require 'chapter'

class Section
  attr_reader :name

  def initialize(name, chapter_list, offset: 0)
    @name = name
    @chapter_list = chapter_list
    @offset = offset
  end

  def name?
    return true unless name.nil?
  end

  def chapters
    @chapters ||= @chapter_list.map.with_index do |name, num|
      if appendices?
        Chapter.new num, name, appendix: true
      else
        Chapter.new chapter_offset(num), name
      end
    end
  end

  def chapter_length
    @chapter_list.size
  end

  def self.create_from_chapters(chapters)
    self.new(nil, chapters)
  end

  def overview
    (name_overview + chapter_overview).join "\n"
  end

  def to_md
    (name_md + chapter_md).join "\n"
  end

  private

  def appendices?
    return false unless name
    name.downcase.include?('appendix') || name.downcase.include?('appendices')
  end

  def chapter_pad
    return indent size: 2 if name?
    indent
  end

  def indent(size: 1)
    '  ' * size
  end

  def name_md
    return ["1. **#{name}**"] if name?
    []
  end

  def name_overview
    return ["#{indent}#{name}"] if name?
    []
  end

  def chapter_overview
    chapters.map { |chapter| "#{chapter_pad}#{chapter}" }
  end

  def chapter_md
    chapters.map(&:readme_md).map { |chapter| "#{indent}- #{chapter}" }
  end

  def chapter_offset(num)
    num + @offset
  end
end
