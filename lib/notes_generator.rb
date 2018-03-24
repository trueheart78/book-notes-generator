require 'fileutils'

class NotesGenerator
  def initialize(book, config)
    @book = book
    @config = config
  end

  def run
    create_directory
    download_image if image.valid?
    write_readme
    write_chapters
    inform_user
  end

  private

  attr_reader :book, :config

  def rollback
    exit 1
  end

  def inform_user
    puts [
      spacer,
      '',
      'Please add the following to the root README.md file:',
      '',
      "1. [#{book.title} (#{book.year})](#{relative_readme_path})",
      '',
      spacer,
      '',
      'Book notes generated successfully.'
    ].join "\n"
  end

  def spacer
    '*' * 70
  end

  def create_directory
    FileUtils::mkdir book.directory
  end

  def write_readme
    File.open(readme_path, 'wb') do |file|
      puts book.to_md
      file.write book.to_md
    end
  end

  def readme_path
    File.join book.directory, 'README.md'
  end

  def relative_readme_path
    File.join book.relative_directory, 'README.md'
  end

  def write_chapters
    book.chapter_list.each_with_index do |chapter, index|
      File.open(File.join(book.directory, chapter.file_name), 'wb') do |file|
        file.write chapter.to_md(previous: previous_chapter(index),
                                 upcoming: upcoming_chapter(index))
      end
    end
  end

  def previous_chapter(index)
    return {} if index.zero?
    {
      name: book.chapter_list[(index-1)].name,
      file_name: book.chapter_list[(index-1)].file_name
    }
  end

  def upcoming_chapter(index)
    return {} if index >= (book.chapter_list.size - 1)
    {
      name: book.chapter_list[(index+1)].name,
      file_name: book.chapter_list[(index+1)].file_name
    }
  end

  def download_image
    return @image_saved if @image_saved
    output_path = File.join "#{book.directory}", "#{image.file_name}"
    @image_saved = system 'wget', '-q', '-O', output_path, "#{image.url}"
  end

  def image_saved?
    download_image
  end

  def image
    @book.image
  end
end
