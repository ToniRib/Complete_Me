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
    list = stringify(list) if list.is_a?(Array)

    list.split("\n").each do |word|
      insert(word) unless word_exists(word)
    end
  end

  def word_exists(word)
    words.include?(word)
  end

  def stringify(list)
    list.join("\n")
  end
end
