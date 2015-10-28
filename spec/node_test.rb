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
    node = Node.new
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

  def test_can_insert_link_to_single_letter_node_from_empty_node
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

  def test_finds_a_substring_that_is_not_a_valid_word
    node = Node.new
    node.insert('happy')

    assert_equal 'hap', node.search('hap').value
  end

  def test_searching_for_a_string_does_not_raise_selection_count
    node = Node.new
    node.insert('happy')
    node.search('happy')

    assert_equal 0, node.search('happy').select_count
  end

  def test_returns_possible_matches_for_suggestion
    node = Node.new

    words = %w(can cannibal canister cannoli cane)
    words.each { |word| node.insert(word) }

    expected = words.sort
    matches = node.suggest('ca')

    assert_equal expected, matches.sort
  end

  def test_returns_different_matches_for_different_suggested_string
    node = Node.new

    words = %w(can cannibal canister cannoli cane)
    words.each { |word| node.insert(word) }

    expected = %w(cannibal cannoli)
    matches = node.suggest('cann')

    assert_equal expected, matches.sort
  end

  def test_search_returns_original_string_as_match_if_it_is_a_valid_word
    node = Node.new

    words = %w(can cannibal canister cannoli cane)
    words.each { |word| node.insert(word) }

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
    words.each { |word| node.insert(word) }

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
    words.each { |word| node.insert(word) }

    suggestions1 = %w(intellect intelligence insight inside in)
    assert_equal suggestions1, node.suggest('in')

    node.select('insight')

    assert_equal 'insight', node.suggest('in')[0]
  end

  def test_suggestions_returned_in_order_of_selection_count
    node = Node.new
    words = %w(in inside intelligence intellect insight)
    words.each { |word| node.insert(word) }

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

  def test_returns_error_if_suggest_string_does_not_exist
    node = Node.new
    node.insert('hello')

    fail_message = 'Cannot find search string in Trie'

    e = assert_raises(RuntimeError) { node.suggest('apple') }
    assert_equal fail_message, e.message
  end

  def tests_find_returns_nil_if_node_has_no_valid_words
    node = Node.new

    refute node.find_words_and_counts
  end

  def test_finds_single_word_with_counts_linked_to_node
    node = Node.new
    node.insert('hello')

    expected = ['hello', 0]

    assert_equal expected, node.find_words_and_counts
  end

  def test_finds_all_valid_words_with_default_counts_linked_to_node
    node = Node.new
    words = %w(in inside intelligence intellect insight)
    words.each { |word| node.insert(word) }

    expected = ['in', 0, 'inside', 0, 'insight', 0, 'intelligence', 0, 'intellect', 0]

    assert_equal expected, node.find_words_and_counts
  end

  def test_finds_all_valid_words_with_select_counts_linked_to_node
    node = Node.new
    words = %w(in inside intelligence intellect insight)
    words.each { |word| node.insert(word) }

    5.times { node.select('inside') }
    3.times { node.select('intellect') }

    expected = ['in', 0, 'inside', 5, 'insight', 0,
                'intelligence', 0, 'intellect', 3]

    assert_equal expected, node.find_words_and_counts
  end

  def test_sort_and_collect_suggestions_returns_suggestions_in_sorted_order
    node = Node.new

    input = [['in', 0], ['inside', 5], ['insight', 0],
             ['intelligence', 0], ['intellect', 3]]

    expected = %w(inside intellect insight intelligence in)

    assert_equal expected, node.sort_and_collect_suggestions(input)
  end

  def test_recognizes_empty_node_as_node_with_no_links_and_not_valid_word
    node = Node.new

    assert node.no_links_and_not_valid_word
  end

  def test_recognizes_single_node_as_node_with_no_links_and_not_valid_word
    node = Node.new('a')

    assert node.no_links_and_not_valid_word
  end

  def test_recognizes_if_node_has_links
    node = Node.new
    node.insert('hi')

    refute node.no_links_and_not_valid_word
  end

  def test_recognizes_if_node_is_valid_word
    node = Node.new
    node.valid_word = true

    refute node.no_links_and_not_valid_word
  end

  def test_find_substring_finds_word_that_starts_with_string
    node = Node.new
    node.insert('app')

    assert_equal ['app', 0], node.find_words_and_counts_with_substring('ap')
  end

  def test_find_substring_finds_word_that_contains_string_in_middle
    node = Node.new
    node.insert('happy')

    assert_equal ['happy', 0], node.find_words_and_counts_with_substring('ap')
  end

  def test_find_substring_finds_multiple_words_matching_string
    node = Node.new
    words = %w(appetite apple happy pepper)
    words.each { |word| node.insert(word) }

    expected = ['appetite', 0, 'apple', 0, 'happy', 0, 'pepper', 0]

    assert_equal expected, node.find_words_and_counts_with_substring('pp')
  end

  def test_find_substring_ignores_words_that_dont_match
    node = Node.new
    words = %w(appetite apple happy pepper pp banana pear)
    words.each { |word| node.insert(word) }

    expected = ['appetite', 0, 'apple', 0, 'happy', 0, 'pepper', 0, 'pp', 0]

    assert_equal expected, node.find_words_and_counts_with_substring('pp')
  end

  def test_suggest_all_returns_only_selections_that_include_substring
    node = Node.new
    words = %w(appetite apple happy pepper pp banana pear)
    words.each { |word| node.insert(word) }

    expected = %w(appetite apple happy pepper pp).reverse

    assert_equal expected, node.suggest_all('pp')
  end

  def test_suggest_all_returns_highly_selected_words_first
    node = Node.new
    words = %w(appetite apple happy pepper pp banana pear)
    words.each { |word| node.insert(word) }

    5.times { node.select('apple') }
    3.times { node.select('happy') }

    expected = %w(apple happy pp pepper appetite)

    assert_equal expected, node.suggest_all('pp')
  end

  def test_find_substring_returns_error_if_string_not_found
    node = Node.new
    words = %w(appetite apple happy pepper pp banana pear)
    words.each { |word| node.insert(word) }

    fail_message = "Cannot find any words containing 'z' in Trie"

    e = assert_raises(RuntimeError) { node.suggest_all('z') }
    assert_equal fail_message, e.message
  end
end
