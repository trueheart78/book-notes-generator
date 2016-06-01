require 'yaml'
require 'chapter'
require 'section'

class Book
  def initialize(yaml_file, config)
    @yaml_file = yaml_file
    @config = config
  end

  def overview
    [
      "- Directory: #{relative_directory}",
      "- Path: #{directory}",
      "- Title: #{title}",
      "- Purchase: #{purchase}",
      "- Author: #{author}",
      "- Homepage: #{homepage}",
      "- Image? #{image?} [#{image_ext}]",
      "   #{image}",
      "- Chapters: #{chapter_length}",
    ].concat(chapter_overview).join "\n"
  end

  def directory
    [config.notes_path, title_as_directory].join '/'
  end

  def relative_directory
    config.compose_notes_dir(title_as_directory)
  end

  def chapter_length
    chapters.size
  end

  def chapter_list
    @chapters ||= chapters.map.with_index { |name, num| Chapter.new num, name }
  end

  def image?
    return true if image && !image.empty?
    false
  end

  def image_file
    "cover.#{image_ext}"
  end

  def to_md
    @md ||= [
      '[&lt;&lt; Back to project home](../../README.md)',
      '',
      "# #{title}",
      '',
      "By the #{adjective} [#{author}](#{homepage})",
      '',
      '## Links:',
      '',
      "- [Purchase #{title}](#{purchase})",
      '',
      '## Chapter Notes:',
      ''
    ].concat(chapter_md).concat(image_md).join "\n"
  end

  def to_s
    "'#{title}' by #{author} :: #{chapter_length} chapters"
  end

  def method_missing(method_name, *arguments, &block)
    if attr_list.include?(method_name)
      yaml_data.send(:[], method_name)
    else
      super
    end
  end

  def respond_to_missing?(method_name, include_private = false)
    attr_list.include?(method_name) || super
  end

  private

  def title_as_directory
    title.downcase.gsub(/[^0-9a-z.\-]/, '-')
  end

  def chapter_overview
    chapter_list.map { |x| left_pad(x) }
  end

  def left_pad(string)
    "   #{string}"
  end

  def chapter_md
    chapter_list.map(&:readme_md).map { |chapter| "- #{chapter}" }
  end

  def image_md
    return [ '', "![book cover](#{image_file})" ] if image?
    []
  end

  def yaml_file
    @yaml_file
  end

  def yaml_data
    @yaml_data ||= load_yaml_file
  end

  def load_yaml_file
    YAML.load_file(yaml_file).tap do |yaml|
      unless yaml.has_key? :sections
        yaml[:sections] = [{name: nil, chapters: yaml[:chapters]}]
        #yaml.delete :chapters
      end
    end
  end

  def config
    @config
  end

  def attr_list
    [:title, :purchase, :author, :homepage, :image, :image_ext, :chapters, :sections]
  end

  def adjective
    %w{fantastic grand marvelous terrific tremendous wondrous howling rattling}.sample
  end
end
