require 'pry'

class Node
  attr_reader :value
  attr_accessor :valid_word, :links

  def initialize(value = '')
    @value = value
    @valid_word = false
    @links = {}
  end

  def word?
    @valid_word
  end

  def insert(str, position = 0)
    @valid_word = true if str.length == position

    return if str[position].nil?

    letter = str[position]

    if links[letter].nil?
      links[letter] = Node.new(str[0..position])
    end

    links[letter].insert(str, position + 1)
  end

  def search(str, position = 0)
    letter = str[position]

    return links if links[letter].nil?

    links[letter].search(str, position + 1)
  end

  # need to refactor
  def find_valid_words(links)
    matches = []

    links.keys.each do |k|
      if links[k].valid_word
        matches.push(links[k].value)
      end
      matches << find_valid_words(links[k].links) if links[k].links != {}
    end

    matches.flatten
  end

  def suggest(str)
    links_of_match = search(str)
    find_valid_words(links_of_match)
  end
end

if __FILE__ == $0
  node = Node.new
  node.insert('abc')
  # binding.pry
  p node
end
