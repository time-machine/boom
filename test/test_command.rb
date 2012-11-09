require 'helper'

# intercept STDOUT and collect it
class Boom::Command
  def self.capture_output
    @output = ''
  end

  def self.captured_output
    @output
  end

  def self.output(s)
    @output << s
  end
end

class TestCommand < Test::Unit::TestCase
  def setup
    Boom::Storage.any_instance.expects(:json_file).
      returns('test/examples/urls.json')
    @storage = Boom::Storage.new
  end

  def command(cmd)
    cmd = cmd.split(' ') if cmd
    Boom::Command.capture_output
    Boom::Command.execute(@storage, *cmd)
    Boom::Command.captured_output
  end

  def test_overview
    assert_equal '  urls (2)', command(nil)
  end

  def test_list_detail
    assert_match /github/, command('urls')
  end

  def test_list_creation
    assert_match /a new list called "newlist"/, command('newlist')
  end

  def test_item_access
    assert_match /copied https:\/\/github\.com to your clipboard/,
      command('github')
  end

  def test_item_access_scoped_by_list
    assert_match /copied https:\/\/github\.com to your clipboard/,
      command('urls github')
  end

  def test_list_deletion_no
    Boom::Command.stubs(:gets).returns('n')
    assert_match /Just kidding then/, command('urls delete')
  end

  def test_list_deletion_yes
    Boom::Command.stubs(:gets).returns('y')
    assert_match /Deleted all your urls/, command('urls delete')
  end
end
