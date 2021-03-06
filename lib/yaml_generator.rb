# frozen_string_literal: true

require_relative 'file_system'

class YamlGenerator < FileSystem
  def run
    validate
    create if valid?
  end

  def to_s
    content
  end

  private

  def create
    File.open(yaml_file_path, 'w') do |file|
      file.puts content
    end
    puts "File created: #{yaml_file_path}"
  end

  def validate_file
    @errors << { message: 'No file passed' } if file.empty?
    @errors << { message: "File exists (#{yaml_file_path})" } if File.exist? yaml_file_path
  end

  def content
    <<~YAML
      ---
      :title:
      :year:
      :purchase:
      :author:
      :homepage:
      :image:
      :image_ext:

      :sections:
        -
          :name:
          :chapters:
          - chapter
        -
          :name: Section 1
          :chapters:
          - chapter
    YAML
  end
end
