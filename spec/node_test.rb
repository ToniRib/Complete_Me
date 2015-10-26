require 'minitest/autorun'
require 'minitest/pride'
require './lib/node'

class NodeTest < Minitest::Test
  def test_node_exists
    assert Node
  end

  def test_node_value_is_empty_string_by_default
    node = Node.new

    assert_equal '', node.value
  end

  def test_node_has_a_value
    node = Node.new('p')

    assert_equal 'p', node.value
  end

  def test_node_is_not_a_word_by_default
    node = Node.new('piz')

    refute node.word?
  end

  def test_node_can_be_recognized_as_valid_word
    node = Node.new('hello')
    node.valid_word = true

    assert node.word?
  end

  def test_node_has_a_links_hash_that_is_empty_by_default
    node = Node.new('a')

    assert_equal Hash.new, node.links
  end
end
