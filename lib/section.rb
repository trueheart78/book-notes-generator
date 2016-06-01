class Section
  attr_reader :name, :chapters

  def initialize

  end

  def name?
    return true unless name.nil?
  end

  def to_md
    return '' unless name?
    "- **#{name}**"
  end
end
