class Chapter
  attr_reader :num, :name, :file

  def initialize(num, name, appendix: false, zero_based: true)
    @num = num
    @num += 1 if zero_based
    @name = name
    @appendix = appendix
  end

  def to_s
    "#{num_str}. #{name} - #{file_name}"
  end

  def file_name
    "#{file_name_prefix}#{num_str}-#{name_as_file}.md"
  end

  def readme_md
    "[#{proper_name}](#{file_name})"
  end

  def to_md(previous: {}, upcoming: {})
    navigation = navigation_md previous, upcoming
    @md ||= [
      navigation,
      '',
      "# #{proper_name}",
      '',
      '*Notes forthcoming*',
      '',
      navigation
    ].join "\n"
  end

  private

  attr_reader :appendix

  def navigation_md(previous, upcoming)
    if previous.empty? && upcoming.empty?
      '[&lt;&lt; Back to the README](README.md)'
    else
      [
        navigation_item_md(previous, :back),
        navigation_item_md(readme, :center),
        navigation_item_md(upcoming, :forward),
      ].join " | "
    end
  end

  def readme
    {
      name: 'README',
      file_name: 'README.md'
    }
  end

  def navigation_item_md(item, direction = :back)
    case direction
    when :back
      "[&lt;&lt; #{item[:name]}](#{item[:file_name]})"
    when :forward
      "[#{item[:name]} &gt;&gt;](#{item[:file_name]})"
    when :center
      "[#{item[:name]}](#{item[:file_name]})"
    end
  end

  def proper_name
    "#{proper_name_prefix} #{num}. #{name}"
  end

  def proper_name_prefix
    return 'Appendix' if appendix?
    'Chapter'
  end

  def file_name_prefix
    return 'ap' if appendix?
    'ch'
  end

  def appendix?
    appendix
  end

  def num_str
    return "0#{num}" if num < 10
    num.to_s
  end

  def name_as_file
    name.gsub(/[?'!,":]/,'').
      gsub(/\-/,' ').
      gsub(/\s\s\s/,' ').
      gsub(/\s\s/,' ').
      gsub(/!=/,'is not').
      downcase.
      gsub(/[^0-9a-z.\-]/, '-')
  end
end
