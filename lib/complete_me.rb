require_relative 'node'

# Class for auto-completion suggestions
class CompleteMe
  attr_reader :count, :center

  def initialize
    @center = Node.new
    @count = 0
  end

  def insert(word)
    fail 'insert only accepts single string argument' unless string?(word)
    center.insert(word.downcase)
    @count += 1
  end

  def populate(list)
    fail 'only accepts strings or arrays' unless string_or_array?(list)

    list = convert_to_array(list)

    t1 = Time.now
    list.each { |word| center.insert(word) }
    t2 = Time.now
    puts "Elapsed time to create Trie: #{t2 - t1} seconds."

    t3 = Time.now
    @count = center.count_valid_words
    t4 = Time.now
    puts "Elapsed time to count: #{t4 - t3} seconds."
  end

  def suggest(str)
    center.suggest(str)
  end

  def select(str, selection)
    center.select(selection)
  end

  private

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
end

if __FILE__ == $PROGRAM_NAME
  completion = CompleteMe.new
  completion.insert('toni')

  t1 = Time.now
  dict = File.read('/usr/share/dict/words')
  t2 = Time.now
  puts "Elapsed time to read: #{t2 - t1} seconds."
  completion.populate(dict)

  puts completion.count
  p completion.suggest('toni')
end
