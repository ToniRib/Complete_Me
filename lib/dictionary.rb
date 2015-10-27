require 'pry'

class Dictionary
  attr_reader :words

  def initialize
    @words = []
  end

  def insert(word)
    @words << word unless word_exists(word)
  end

  def mass_insert(list)
    if string?(list)
      @words = words | list.split("\n")
    elsif array?(list)
      @words = words | list
    else
      fail "Unrecognized input data type"
    end
  end

  def word_exists(word)
    words.include?(word)
  end

  def string?(list)
    list.is_a?(String)
  end

  def array?(list)
    list.is_a?(Array)
  end
end
