require_relative 'dictionary'
require_relative 'node'

class CompleteMe
  attr_reader :dictionary, :center

  def initialize
    @center = Node.new

    #maybe don't need dictionary, will need to consider
    @dictionary = Dictionary.new
  end

  def insert(word)
    @dictionary.insert(word)
    @center.insert(word)
  end

  def populate(list)
    @dictionary.mass_insert(list)
  end

  def count
    @dictionary.words.count
  end
end

if __FILE__ == $0
  completion = CompleteMe.new
  completion.insert('toni')
  completion.count
  # binding.pry
  dict = File.read("/usr/share/dict/words")
  completion.populate(dict)
  binding.pry
end
