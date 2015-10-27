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

  def test_default_word_count_is_zero
    completion = CompleteMe.new

    assert_equal 0, completion.count
  end

  def test_ignores_insertion_of_empty_string
    completion = CompleteMe.new
    completion.insert('')

    assert_equal Hash.new, completion.center.links
  end

  def test_can_insert_a_single_word
    completion = CompleteMe.new
    completion.insert('hi')

    assert_equal 'h', completion.center.links.keys[0]
  end

  def test_insert_rejects_array_of_two_strings
    completion = CompleteMe.new
    fail_message = 'insert method only accepts a single string argument'

    e = assert_raises("RuntimeError") { completion.insert(%w(hello hi)) }
    assert_equal fail_message, e.message
  end

  def test_insert_rejects_number
    completion = CompleteMe.new
    fail_message = 'insert method only accepts a single string argument'

    e = assert_raises("RuntimeError") { completion.insert(1) }
    assert_equal fail_message, e.message
  end

  def test_insert_rejects_hash
    completion = CompleteMe.new
    fail_message = 'insert method only accepts a single string argument'

    e = assert_raises("RuntimeError") { completion.insert({ a: 1 }) }
    assert_equal fail_message, e.message
  end
end
