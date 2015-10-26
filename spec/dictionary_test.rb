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

  def test_dictionary_can_contain_multiple_words
    dictionary = Dictionary.new
    dictionary.insert('banana')
    dictionary.insert('apple')

    assert_equal 2, dictionary.words.size
    assert dictionary.words.include?('banana')
    assert dictionary.words.include?('apple')
  end

  def test_multiple_words_can_be_inserted_at_once
    dictionary = Dictionary.new
    list = %w(banana apple orange pear)
    dictionary.mass_insert(list)

    assert_equal 4, dictionary.words.count
    list.each do |word|
      assert dictionary.words.include?(word)
    end
  end

  def test_duplicate_words_are_ignored
    dictionary = Dictionary.new
    list = %w(banana apple banana pear)
    dictionary.mass_insert(list)

    assert_equal 3, dictionary.words.count
  end
end
