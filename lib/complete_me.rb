require_relative 'node'

class CompleteMe
  attr_reader :dictionary, :center

  def initialize
    @center = Node.new
  end

  def insert(word)
    center.insert(word)
  end

  def populate(list)
    t1 = Time.now
    list.split("\n").each do |word|
      center.insert(word)
    end
    t2 = Time.now
    puts "Elapsed Time: #{t2 - t1} seconds"
  end

  def count
    @center.count_valid_words
  end

  def suggest(str)
    center.suggest(str)
  end
end

if __FILE__ == $0
  completion = CompleteMe.new
  completion.insert('toni')
  completion.count
  dict = File.read("/usr/share/dict/words")
  completion.populate(dict)
  p completion.suggest('piz')
end
