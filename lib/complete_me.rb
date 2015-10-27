require_relative 'node'

# Class for auto-completion suggestions
class CompleteMe
  attr_reader :count, :center

  def initialize
    @center = Node.new
    @count = 0
  end

  def convert_to_array(list)
    array?(list) ? list : list.split("\n")
  end

  def string_or_array?(list)
    string?(list) || array?(list)
  end

  def string?(word)
    word.is_a?(String)
  end

  def array?(list)
    list.is_a?(Array)
  end

  def insert(word)
    fail 'insert only accepts single string argument' unless string?(word)
    center.insert(word.downcase)
    @count += 1
  end

  def populate(list)
    fail 'only accepts strings or arrays' unless string_or_array?(list)

    list = convert_to_array(list)

    list.each { |word| center.insert(word) }

    @count = center.count_valid_words
  end

  def suggest(str)
    center.suggest(str)
  end

  def select(str, selection)
    center.select(selection)
  end
end

if __FILE__ == $PROGRAM_NAME
  completion = CompleteMe.new
  completion.insert('toni')
  puts completion.count
  dict = File.read('/usr/share/dict/words')
  completion.populate(dict)
  puts completion.count
  p completion.suggest('piz')
end
2
