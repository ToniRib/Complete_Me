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

    expected = {}
    assert_equal expected, completion.center.links
  end

  def test_default_word_count_is_zero
    completion = CompleteMe.new

    assert_equal 0, completion.count
  end

  def test_ignores_insertion_of_empty_string
    completion = CompleteMe.new
    completion.insert('')

    expected = {}
    assert_equal expected, completion.center.links
  end

  def test_can_insert_a_single_word
    completion = CompleteMe.new
    completion.insert('hi')

    assert_equal 'h', completion.center.links.keys[0]
    assert_equal 1, completion.count
  end

  def test_count_increases_by_one_for_each_word_inserted
    completion = CompleteMe.new

    completion.insert('hi')
    assert_equal 1, completion.count

    completion.insert('hello')
    assert_equal 2, completion.count
  end

  def test_insert_rejects_array_of_two_strings
    completion = CompleteMe.new
    fail_message = 'insert only accepts single string argument'

    e = assert_raises(RuntimeError) { completion.insert(%w(hello hi)) }
    assert_equal fail_message, e.message
  end

  def test_insert_rejects_two_string_arguments
    completion = CompleteMe.new

    fail_message = 'wrong number of arguments (2 for 1)'

    e = assert_raises(ArgumentError) { completion.insert('hello', 'hi') }
    assert_equal fail_message, e.message
  end

  def test_insert_rejects_number
    completion = CompleteMe.new
    fail_message = 'insert only accepts single string argument'

    e = assert_raises(RuntimeError) { completion.insert(1) }
    assert_equal fail_message, e.message
  end

  def test_insert_rejects_hash
    completion = CompleteMe.new
    fail_message = 'insert only accepts single string argument'

    e = assert_raises(RuntimeError) { completion.insert(a: 1) }
    assert_equal fail_message, e.message
  end

  def test_populate_accepts_string_of_newline_separate_words
    completion = CompleteMe.new

    input = "hello\nhi\nhappy\nbanana\norange"

    completion.populate(input)

    assert_equal 5, completion.count
  end

  def test_populate_accepts_array_of_strings
    completion = CompleteMe.new

    input = %w(hello hi happy banana orange)

    completion.populate(input)

    assert_equal 5, completion.count
  end

  def test_populate_rejects_numbers
    completion = CompleteMe.new
    fail_message = 'only accepts strings or arrays'

    e = assert_raises(RuntimeError) { completion.populate(1) }
    assert_equal fail_message, e.message
  end

  def test_populate_rejects_a_hash
    completion = CompleteMe.new
    fail_message = 'only accepts strings or arrays'

    e = assert_raises(RuntimeError) { completion.populate(a: 2) }
    assert_equal fail_message, e.message
  end

  def test_suggests_matches_for_string
    completion = CompleteMe.new
    completion.populate("banana\napple\nbongo\nbang")

    matches = completion.suggest('ba')
    expected = %w(banana bang)

    assert_equal expected, matches.sort
  end

  def test_suggests_matches_for_different_string
    completion = CompleteMe.new
    completion.populate("banana\napple\nbongo\nbang")

    matches = completion.suggest('b')
    expected = %w(banana bang bongo)

    assert_equal expected, matches.sort
  end

  def test_suggest_returns_selected_words_first
    completion = CompleteMe.new

    completion.populate("banana\nbaseball\nbat")
    completion.select('ba', 'bat')

    assert_equal 'bat', completion.suggest('ba')[0]
  end

  def test_returns_suggestions_with_highest_selection_counts_first
    completion = CompleteMe.new

    completion.populate("bear\nbeat\nbean\nbeanpole\nbetter")

    6.times { completion.select('be', 'beat') }
    4.times { completion.select('be', 'bean') }
    2.times { completion.select('be', 'better') }

    matches = completion.suggest('be')

    assert_equal 'beat', matches[0]
    assert_equal 'bean', matches[1]
    assert_equal 'better', matches[2]
  end

  def test_selection_does_not_consider_first_argument
    completion = CompleteMe.new

    completion.populate("bear\nbeat\nbean\nbeanpole\nbetter")

    6.times { completion.select('be', 'beat') }
    4.times { completion.select('bea', 'bean') }
    2.times { completion.select('bett', 'better') }

    matches = completion.suggest('be')

    assert_equal 'beat', matches[0]
    assert_equal 'bean', matches[1]
    assert_equal 'better', matches[2]
  end

  def test_returns_error_if_suggested_string_does_not_exist
    completion = CompleteMe.new
    completion.insert('banana')

    fail_message = 'Cannot find search string in Trie'

    e = assert_raises(RuntimeError) { completion.suggest('app') }
    assert_equal fail_message, e.message
  end

  def test_returns_error_if_selected_str_does_not_exist
    completion = CompleteMe.new
    completion.insert('banana')

    fail_message = 'Cannot find search string in Trie'

    e = assert_raises(RuntimeError) { completion.select('app', 'apple') }
    assert_equal fail_message, e.message
  end

  def test_suggests_words_that_contain_substring
    completion = CompleteMe.new
    completion.populate("happy\napple\npear\ncrappy\nhappyness")

    expected = %w(crappy apple happyness happy)

    assert_equal expected, completion.suggest_substring('pp')
  end

  def test_suggests_words_that_contain_substring_and_start_with_substring
    completion = CompleteMe.new
    completion.populate("happy\napple\npear\ncrappy\nppe")

    expected = %w(crappy ppe apple happy)

    assert_equal expected, completion.suggest_substring('pp')
  end

  def test_returns_error_if_no_words_found_that_include_substring
    completion = CompleteMe.new
    completion.populate("happy\napple\npear\ncrappy")

    fail_message = "Cannot find any words containing 'z' in Trie"

    e = assert_raises(RuntimeError) { completion.suggest_substring('z') }
    assert_equal fail_message, e.message
  end

  def test_suggest_words_with_substring_and_ranks_by_select_count
    completion = CompleteMe.new
    completion.populate("happy\napple\npear\ncrappy\nunhappy")

    5.times { completion.select('pp', 'happy') }
    3.times { completion.select('pp', 'apple') }

    expected = %w(happy apple crappy unhappy)

    assert_equal expected, completion.suggest_substring('pp')
  end
end
