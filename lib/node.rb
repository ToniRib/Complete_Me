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
    return if str[position].nil?

    letter = str[position]

    if links[letter] == nil
      links[letter] = Node.new(str[0..position])
    end
    links[letter].insert(str, position + 1)
  end
end

node = Node.new
node.insert('abc')
# binding.pry
p node
