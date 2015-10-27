require 'pry'

class Dictionary
  attr_reader :words

  def initialize
    @words = []
  end

  def insert(word)
    @words << word unless word_exists(word)
  end

  # should probably include rejection of other data types

  def mass_insert(list)
    if not_array?(list)
      @words = words | list.split("\n")
    else
      @words = words | list
    end
  end

  def word_exists(word)
    words.include?(word)
  end

  def not_array?(list)
    !list.is_a?(Array)
  end
end
