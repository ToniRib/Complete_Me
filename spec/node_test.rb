require 'minitest/autorun'
require 'minitest/pride'
require './lib/node'

class NodeTest < Minitest::Test
  def test_node_exists
    assert Node
  end

  def test_node_has_a_value
    node = Node.new('p')

    assert_equal 'p', node.value
  end

  def method_name

  end
end
