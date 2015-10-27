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

  def test_insert_rejects_array_of_two_strings
    completion = CompleteMe.new
    fail_message = 'insert only accepts single string argument'

    e = assert_raises(RuntimeError) { completion.insert(%w(hello hi)) }
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
end
