require 'yaml'
require 'chapter'
require 'section'
require 'image'

class Book
  def initialize(yaml_file, config)
    @yaml_file = yaml_file
    @config = config
  end

  def directory
    config.notes_path.join title_as_directory
  end

  def relative_directory
    config.compose_notes_dir title_as_directory
  end

  def chapter_length
    sections.map(&:chapter_length).inject(&:+)
  end

  def chapter_list
    sections.map(&:chapters).flatten
  end

  def image
    @image ||= Image.new yaml_data[:image], yaml_data[:image_ext]
  end

  def overview
    [
      "- Directory: #{relative_directory}",
      "- Path: #{directory}",
      "- Title: #{title}",
      "- Purchase: #{purchase}",
      "- Author: #{author}",
      "- Homepage: #{homepage}",
      "- Image? #{image.valid?} [#{image.ext}]",
      "   #{image.url}",
      "- Chapters: #{chapter_length}",
    ].concat(section_overview).join "\n"
  end

  def to_md
    @md ||= [
      "[&lt;&lt; Back to project home](#{readme_path})",
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
    ].concat(section_md).concat(image_md).join "\n"
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

  attr_reader :yaml_file, :config

  def sections
    @sections ||= load_sections
  end

  def load_sections
    @sections = []
    chapter_offset = 0
    yaml_data[:sections].each do |s|
      @sections << Section.new(s[:name], s[:chapters], offset: chapter_offset)
      chapter_offset += s[:chapters].size
    end
    @sections
  end

  def readme_path
    File.join config.relative_path, 'README.md'
  end

  def title_as_directory
    title.downcase.gsub(/[^0-9a-z.\-]/, '-')
  end

  def section_overview
    sections.map(&:overview)
  end

  def left_pad(string)
    "   #{string}"
  end

  def section_md
    sections.map(&:to_md)
  end

  def image_md
    return [ '', image.to_md ] if image.valid?
    []
  end

  def yaml_data
    @yaml_data ||= load_yaml_file
  end

  def load_yaml_file
    YAML.load_file(yaml_file).tap do |yaml|
      create_sections(yaml) unless yaml.has_key? :sections
    end
  end

  def create_sections(yaml)
    yaml[:sections] = [{name: nil, chapters: yaml[:chapters]}]
    yaml.delete :chapters
    if yaml.has_key? :appendices
      yaml[:sections] << {name: 'Appendices', chapters: yaml[:appendices]}
      yaml.delete :appendices
    end
    yaml
  end

  def attr_list
    [:title, :purchase, :author, :homepage, :image, :image_ext, :sections]
  end

  def adjective
    %w{fantastic grand marvelous terrific tremendous wondrous howling rattling}.sample
  end
end
