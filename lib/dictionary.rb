require 'pry'

class Dictionary
  attr_reader :words

  def initialize
    @words = []
  end

  def insert(word)
    @words << word
  end

  def mass_insert(list)
    list.split("\n").each do |word|
      insert(word)
    end
  end
end
