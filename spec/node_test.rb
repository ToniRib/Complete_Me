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

  def test_single_letter_node_has_empty_links_hash
    node = Node.new('a')

    assert_equal Hash.new, node.links
  end

  def test_can_insert_link_to_single_letter_node
    node = Node.new
    node.insert('a')

    assert_equal 1, node.links.count
    assert_equal ['a'], node.links.keys
    assert node.links.values[0].is_a?(Node)
  end

  def test_does_not_duplicate_links
    skip
    node = Node.new
    node.insert('a')
    node.insert('a')

    assert_equal 1, node.links.count
    assert_equal ['a'], node.links.keys
  end

  def test_can_insert_links_to_two_letter_node
    skip
    node = Node.new
    node.insert('ab')
    p node

    assert_equal 1, node.links.count
    assert_equal ['a'], node.links.keys

    #additional testing
  end
end
