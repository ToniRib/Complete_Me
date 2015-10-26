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

    assert_equal 2, dictionary.words.count
    assert dictionary.words.include?('banana')
    assert dictionary.words.include?('apple')
  end

  def test_multiple_newline_separated_words_can_be_inserted_at_once
    dictionary = Dictionary.new
    list = "banana\napple\norange\npear"
    dictionary.mass_insert(list)

    assert_equal 4, dictionary.words.count
    list.split("\n").each do |word|
      assert dictionary.words.include?(word)
    end
  end

  def test_duplicate_words_are_ignored
    dictionary = Dictionary.new
    list = "banana\napple\nbanana\npear"
    dictionary.mass_insert(list)

    assert_equal 3, dictionary.words.count
  end

  def test_returns_true_if_word_exists_in_dictionary
    dictionary = Dictionary.new
    dictionary.insert('banana')

    assert dictionary.word_exists('banana')
  end

  def test_returns_false_if_word_is_not_in_dictionary
    dictionary = Dictionary.new
    dictionary.insert('banana')

    refute dictionary.word_exists('apple')
  end

  def test_will_accept_array_as_input
    dictionary = Dictionary.new
    dictionary.mass_insert(%w(apple banana orange pear))

    assert_equal 4, dictionary.words.count
  end

  def test_mass_insert_works_with_just_one_word
    dictionary = Dictionary.new
    dictionary.mass_insert('banana')

    assert_equal 1, dictionary.words.count
  end
end
