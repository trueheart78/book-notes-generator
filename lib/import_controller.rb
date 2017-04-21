require_relative 'file_system'

class ImportController < FileSystem

  def run
    validate
    get_user_approval
    import if looks_good?
  end

  private

  def get_user_approval
    prompt_user if valid? && user_viewed?
    @user_input = 'y' unless user_viewed?
  end

  def looks_good?
    valid? && user_approved?
  end

  def prompt_user
    puts book.overview
    puts '---------------------'
    puts "Import #{book}? (y/n)"
    @user_input = STDIN.gets.chomp.downcase[0] until ['y','n'].include? @user_input
  end

  def user_approved?
    @user_input == 'y'
  end

  def user_viewed?
    ENV['NODE_ENV'] != 'test'
  end

  def import
    generator = NotesGenerator.new book, config
    generator.run
  end

  def book
    @book ||= Book.new yaml_file_path, config
  end

  def validate_file
    @errors << { message: 'No file passed' } if file.empty?
    @errors << { message: "File not found (#{yaml_file_path})" } unless File.exist? yaml_file_path
    @errors << { message: "Directory exists (#{book.directory}/)" } if File.exist? book.directory
  end
end
