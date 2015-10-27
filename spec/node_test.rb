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
    node = Node.new
    node.insert('a')
    node.insert('a')

    assert_equal 1, node.links.count
    assert_equal ['a'], node.links.keys
  end

  def test_can_insert_links_to_two_letter_word
    node = Node.new
    node.insert('ab')

    assert_equal '', node.value
    assert_equal 'a', node.links['a'].value
    assert_equal 'ab', node.links['a'].links['b'].value
  end

  def test_can_insert_links_to_five_letter_word
    # refactor this test
    node = Node.new
    node.insert('hello')

    assert_equal '', node.value
    assert_equal 'h', node.links['h'].value
    assert_equal 'he', node.links['h'].links['e'].value
    assert_equal 'hel', node.links['h'].links['e'].links['l'].value
    assert_equal 'hell', node.links['h'].links['e'].links['l'].links['l'].value
    assert_equal 'hello', node.links['h'].links['e'].links['l'].links['l'].links['o'].value
  end

  def test_can_insert_two_multiletter_words
    node = Node.new
    node.insert('ab')
    node.insert('acd')

    assert_equal '', node.value
    assert_equal 'a', node.links['a'].value
    assert_equal 'ab', node.links['a'].links['b'].value
    assert_equal 'ac', node.links['a'].links['c'].value
    assert_equal 'acd', node.links['a'].links['c'].links['d'].value
  end

  def test_sets_node_whose_value_is_inserted_string_to_valid_word
    node = Node.new
    node.insert('hi')

    refute node.valid_word
    refute node.links['h'].valid_word
    assert node.links['h'].links['i'].valid_word
  end

  def test_finds_child_nodes_that_are_valid_words
    skip
  end

  def test_finds_node_with_given_value
    node = Node.new
    node.insert('hello')

    assert_equal 'hello', node.search('hello').value
  end

  def test_returns_possible_matches
    node = Node.new
    words = %w(can cannibal canister cannoli cane)
    words.each do |word|
      node.insert(word)
    end

    all_matches = node.suggest('ca')

    assert_equal [], words - all_matches
    assert_equal %w(cannibal cannoli), node.suggest('cann')
  end

  def test_search_returns_original_string_as_match_if_it_is_a_valid_word
    node = Node.new
    words = %w(can cannibal canister cannoli cane)
    words.each do |word|
      node.insert(word)
    end

    assert node.suggest('can').include?('can')
  end

  def test_empty_node_has_no_valid_words
    node = Node.new

    assert_equal 0, node.count_valid_words
  end

  def test_count_returns_one_if_node_only_contains_one_valid_word
    node = Node.new
    node.insert('hello')

    assert_equal 1, node.count_valid_words
  end

  def test_counts_returns_total_number_of_valid_words
    node = Node.new
    words = %w(can cannibal canister cannoli cane a)
    words.each do |word|
      node.insert(word)
    end

    assert_equal 6, node.count_valid_words
  end
end
