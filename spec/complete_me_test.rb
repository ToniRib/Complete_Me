require 'minitest/autorun'
require 'minitest/pride'
require './lib/complete_me'

class CompleteMeTest < Minitest::Test
  def test_complete_me_exists
    assert CompleteMe
  end

  def test_center_node_has_empty_string_value_as_default
    completion = CompleteMe.new

    assert_equal '', completion.center.value
  end

  def test_center_node_has_empty_links_hash_as_default
    completion = CompleteMe.new

    assert_equal Hash.new, completion.center.links
  end
end
