Shoes.app(width:350, height: 500) do
  background "#1fb2cc"

  stack(margin: 12) do
    title "CompleteMe"

    para "Enter string to get suggestions:"

    flow do
      @e = edit_line width: 100
      @push = button "search"
    end
    @s = para 'no suggestions yet...'

    @push.click {
      @matches = @completion.suggest(@e.text)
      @s.replace @matches.join("\n")
    }
  end

  dictionary = File.read('/usr/share/dict/words')
  @completion = CompleteMe.new
  @completion.populate(dictionary)
end

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

    list.each { |word| center.insert(word) }

    @count = center.count_valid_words
  end

  def suggest(str)
    center.suggest(str)
  end

  def select(_str, selection)
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

class Node
  attr_reader :value
  attr_accessor :valid_word, :links, :select_count

  def initialize(value = '')
    @value = value
    @valid_word = false
    @links = {}
    @select_count = 0
  end

  def word?
    @valid_word
  end

  def insert(str, pos = 0)
    return if str.empty?

    fail 'Second argument must be an integer' unless fixnum?(pos)

    letter = str[pos]
    create_link_if_it_doesnt_exist(str, letter, pos)

    set_valid_word_or_keep_inserting_links(str, letter, pos)
  end

  def create_link_if_it_doesnt_exist(str, letter, pos)
    links[letter] = Node.new(str[0..pos]) if link_does_not_exist(letter)
  end

  def set_valid_word_or_keep_inserting_links(str, letter, pos)
    if end_of_string?(str, pos)
      links[letter].valid_word = true
    else
      links[letter].insert(str, pos + 1)
    end
  end

  def fixnum?(x)
    x.is_a?(Fixnum)
  end

  def link_does_not_exist(letter)
    links[letter].nil?
  end

  def search(str, pos = 0)
    letter = str[pos]

    return links[letter] if end_of_string?(str, pos)

    fail 'Cannot find search string in Trie' if link_does_not_exist(letter)

    links[letter].search(str, pos + 1)
  end

  def end_of_string?(str, pos)
    str.length == pos + 1
  end

  def find_words_and_counts
    return nil if no_links_and_not_valid_word

    matches = []
    matches.concat(value_count_pair) if word?

    matches << links.keys.map { |k| links[k].find_words_and_counts }

    matches.flatten
  end

  def value_count_pair
    [value, select_count]
  end

  def count_valid_words
    return 0 if no_links_and_not_valid_word

    count = 0
    count += 1 if valid_word

    links.keys.each { |k| count += links[k].count_valid_words }

    count
  end

  def no_links_and_not_valid_word
    links.empty? && !valid_word
  end

  def suggest(str)
    suggestions = search(str).find_words_and_counts
    suggestions = slice_into_pairs(suggestions)
    sort_and_collect_suggestions(suggestions)
  end

  def slice_into_pairs(arr)
    arr.each_slice(2).to_a
  end

  def sort_and_collect_suggestions(list)
    list = list.sort_by { |_, count| count }.reverse
    list.collect { |idx| idx[0] }
  end

  def select(selection)
    search(selection).select_count += 1
  end
end
