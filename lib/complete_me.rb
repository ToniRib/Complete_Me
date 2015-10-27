require_relative 'dictionary'
require_relative 'node'

class CompleteMe
  attr_reader :dictionary, :center

  def initialize
    @center = Node.new
    @dictionary = Dictionary.new
  end

  def insert(word)
    @dictionary.insert(word)
    @center.insert(word)
    binding.pry
  end

  def populate(list)
    @dictionary.mass_insert(list)
  end
end

if __FILE__ == $0
  completion = CompleteMe.new
  completion.insert('toni')
  # binding.pry
  dict = File.read("/usr/share/dict/words")
  completion.populate(dict)
  binding.pry
end
