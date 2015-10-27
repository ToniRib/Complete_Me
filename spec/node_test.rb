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

  def test_node_is_not_a_word_by_default
    node = Node.new('piz')
    refute node.word?
  end

  def test_node_starts_with_a_selection_count_of_zero
    node = Node.new
    assert_equal 0, node.select_count
  end

  def test_node_has_no_links_by_default
    node = Node.new
    expected = {}
    assert_equal expected, node.links
  end

  def test_node_can_be_initialized_with_a_single_letter_value
    node = Node.new('p')
    assert_equal 'p', node.value
  end

  def test_node_can_be_initialized_with_a_multi_letter_value
    node = Node.new('pi')
    assert_equal 'pi', node.value
  end

  def test_node_can_be_recognized_as_valid_word
    node = Node.new('hello')
    node.valid_word = true

    assert node.word?
  end

  def test_single_letter_node_has_empty_links_hash
    node = Node.new('a')

    expected = {}
    assert_equal expected, node.links
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

  def test_ignores_insertion_of_empty_string
    node = Node.new
    node.insert('')

    assert_equal 0, node.links.count
  end

  def test_can_insert_links_to_new_nodes_for_two_letter_word
    node = Node.new
    node.insert('ab')

    assert_equal '', node.value

    assert_equal 'a', node.links['a'].value
    assert node.links['a'].is_a?(Node)

    assert_equal 'ab', node.links['a'].links['b'].value
    assert node.links['a'].links['b'].is_a?(Node)
  end

  def test_can_insert_links_to_three_letter_word
    node = Node.new
    node.insert('hel')

    assert_equal '', node.value
    assert_equal 'h', node.links['h'].value
    assert_equal 'he', node.links['h'].links['e'].value
    assert_equal 'hel', node.links['h'].links['e'].links['l'].value
  end

  def test_can_insert_two_multiletter_words
    node = Node.new
    node.insert('ab')
    node.insert('acd')

    assert_equal '', node.value
    assert_equal 'a', node.links['a'].value
    assert node.links['a'].is_a?(Node)

    assert_equal 'ab', node.links['a'].links['b'].value
    assert node.links['a'].links['b'].is_a?(Node)

    assert_equal 'ac', node.links['a'].links['c'].value
    assert node.links['a'].links['c'].is_a?(Node)

    assert_equal 'acd', node.links['a'].links['c'].links['d'].value
    assert node.links['a'].links['c'].links['d'].is_a?(Node)
  end

  def test_can_only_insert_one_string_at_a_time
    node = Node.new

    fail_message = 'Second argument must be an integer'

    e = assert_raises(RuntimeError) { node.insert('hello', 'hi') }
    assert_equal fail_message, e.message
  end

  def test_sets_node_whose_value_is_inserted_string_to_valid_word
    node = Node.new
    node.insert('hi')

    refute node.valid_word
    refute node.links['h'].valid_word
    assert node.links['h'].links['i'].valid_word
  end

  def test_fixnum_returns_true_if_input_is_an_integer
    node = Node.new
    assert node.fixnum?(3)
  end

  def test_fixum_returns_false_if_input_is_an_array
    node = Node.new
    refute node.fixnum?([3])
  end

  def test_fixum_returns_false_if_input_is_a_string
    node = Node.new
    refute node.fixnum?('3')
  end

  def test_finds_node_with_given_value
    node = Node.new
    node.insert('hello')

    assert_equal 'hello', node.search('hello').value
  end

  def test_finds_node_with_different_value
    node = Node.new
    node.insert('happy')
    node.insert('hello')

    assert_equal 'happy', node.search('happy').value
  end

  def test_returns_possible_matches_for_suggestion
    node = Node.new

    words = %w(can cannibal canister cannoli cane)
    words.each do |word|
      node.insert(word)
    end

    expected = words.sort
    matches = node.suggest('ca')

    assert_equal expected, matches.sort
  end

  def test_returns_different_matches_for_different_suggested_string
    node = Node.new

    words = %w(can cannibal canister cannoli cane)
    words.each do |word|
      node.insert(word)
    end

    expected = %w(cannibal cannoli)
    matches = node.suggest('cann')

    assert_equal expected, matches.sort
  end

  def test_search_returns_original_string_as_match_if_it_is_a_valid_word
    node = Node.new

    words = %w(can cannibal canister cannoli cane)
    words.each do |word|
      node.insert(word)
    end

    matches = node.suggest('can')

    assert matches.include?('can')
  end

  def test_returns_true_if_no_link_exists_for_specific_letter
    node = Node.new
    node.insert('hi')

    assert node.search('h').link_does_not_exist('p')
  end

  def test_returns_false_if_link_exist_for_specific_letter
    node = Node.new
    node.insert('hi')

    refute node.search('h').link_does_not_exist('i')
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

  def test_select_count_increases_by_one_when_word_is_selected
    node = Node.new
    node.insert('hello')

    node.select('hello')

    assert_equal 1, node.search('hello').select_count
  end

  def test_node_can_be_selected_more_than_once
    node = Node.new
    node.insert('hello')

    3.times { node.select('hello') }

    assert_equal 3, node.search('hello').select_count
  end

  def test_two_nodes_can_be_selected_sequentially
    node = Node.new
    node.insert('hello')
    node.insert('hell')

    3.times { node.select('hell') }
    8.times { node.select('hello') }

    assert_equal 3, node.search('hell').select_count
    assert_equal 8, node.search('hello').select_count
  end

  def test_only_one_node_can_be_selected_at_a_time
    node = Node.new
    node.insert('hello')

    fail_message = 'wrong number of arguments (2 for 1)'

    e = assert_raises(ArgumentError) { node.select('hello', 'hi') }
    assert_equal fail_message, e.message
  end

  def test_selected_node_appears_first_in_suggestions
    node = Node.new
    words = %w(in inside intelligence intellect insight)
    words.each do |word|
      node.insert(word)
    end

    suggestions1 = %w(inside insight intelligence intellect in)
    assert_equal suggestions1.reverse, node.suggest('in')

    node.select('intellect')

    assert_equal 'intellect', node.suggest('in')[0]
  end

  def test_suggestions_returned_in_order_of_selection_count
    node = Node.new
    words = %w(in inside intelligence intellect insight)
    words.each do |word|
      node.insert(word)
    end

    5.times { node.select('inside') }
    3.times { node.select('intelligence') }
    1.times { node.select('insight') }

    assert_equal 'inside', node.suggest('in')[0]
    assert_equal 'intelligence', node.suggest('in')[1]
    assert_equal 'insight', node.suggest('in')[2]
  end

  def test_array_is_sliced_into_pairs
    node = Node.new

    input = [1, 2, 3, 4, 5, 6]
    expected = [[1, 2], [3, 4], [5, 6]]

    assert_equal expected, node.slice_into_pairs(input)
  end

  def test_returns_error_if_search_string_does_not_exist
    node = Node.new
    node.insert('hello')

    fail_message = 'Cannot find search string in Trie' 

    e = assert_raises(RuntimeError) { node.search('apple') }
    assert_equal fail_message, e.message
  end
end
