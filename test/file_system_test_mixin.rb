module FileSystemTestMixin
  def test_responds_to_errors
    assert_respond_to subject, :errors
  end

  def test_respond_to_file
    assert_respond_to subject, :file
  end

  def test_respond_to_validate
    assert_respond_to subject, :validate
  end

  def test_respond_to_validate_bang
    assert_respond_to subject, :validate!
  end

  def test_respond_to_yaml_file_path
    assert_respond_to subject, :yaml_file_path
  end
end
