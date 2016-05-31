require_relative 'test_helper'
require 'section'

class SectionTest < Minitest::Test
  include TestHelper

  def subject
    @subject ||= Section.new
  end
end
