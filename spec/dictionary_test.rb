require 'minitest/autorun'
require 'minitest/pride'
require './lib/dictionary'

class DictionaryTest < Minitest::Test
  def test_dictionary_exists
    assert Dictionary
  end

  def test_dictionary_is_empty_by_default
    dictionary = Dictionary.new
    assert_equal [], dictionary.words
  end

  def test_word_can_be_inserted_into_dictionary
    dictionary = Dictionary.new
    dictionary.insert('banana')
    assert_equal 'banana', dictionary.words[0]
  end
end
