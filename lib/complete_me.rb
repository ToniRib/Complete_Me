require_relative 'node'

class CompleteMe
  attr_reader :count, :center

  def initialize
    @center = Node.new
    @count = 0
  end

  def insert(word)
    center.insert(word)
    @count += 1
  end

  def populate(list)
    list.split("\n").each do |word|
      center.insert(word)
    end
    @count = center.count_valid_words
  end

  def suggest(str)
    center.suggest(str)
  end
end

if __FILE__ == $0
  completion = CompleteMe.new
  completion.insert('toni')
  puts completion.count
  dict = File.read("/usr/share/dict/words")
  completion.populate(dict)
  puts completion.count
  p completion.suggest('piz')
end
