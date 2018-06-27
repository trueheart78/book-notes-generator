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
    links = links_md previous, upcoming
    @md ||= [
      navigation,
      '',
      "# #{proper_name}",
      '',
      '_Notes_',
      '',
      navigation,
      '',
    ].concat(links).join "\n"
  end

  private

  attr_reader :appendix

  def navigation_md(previous, upcoming)
    if previous.empty? && upcoming.empty?
      '[🏡][readme]'
    else
      [].tap do |array|
        if previous.empty?
          array << '[🏡][readme]'
          array << navigation_item_md(upcoming, :upcoming)
        elsif upcoming.empty?
          array << navigation_item_md(previous, :previous)
          array << navigation_item_md(readme, :readme)
        else
          array << navigation_item_md(previous, :previous)
          array << navigation_item_md(readme, :readme)
          array << navigation_item_md(upcoming, :upcoming)
        end
      end.join('&nbsp;'*7)
    end
  end

  def readme
    {
      name: '🏡',
      file_name: 'README.md'
    }
  end

  def navigation_item_md(item, direction = :previous)
    case direction
    when :previous
      "[🔙 #{item[:name]}][previous-chapter]"
    when :upcoming
      "[#{item[:name]} 🔜][upcoming-chapter]"
    when :readme
      "[#{item[:name]}][readme]"
    end
  end

  def links_md(previous, upcoming)
    [].tap do |array|
      array << link_item_md(readme, :readme)
      array << link_item_md(previous, :previous) unless previous.empty?
      array << link_item_md(upcoming, :upcoming) unless upcoming.empty?
    end
  end

  def link_item_md(item, direction = :previous)
    return '[readme]: README.md' if direction == :readme
    "[#{direction}-chapter]: #{item[:file_name]}"
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
      gsub(/[^0-9a-z.\-]/, '-').
      chomp('-').
      gsub(/--/,'-')
  end
end
