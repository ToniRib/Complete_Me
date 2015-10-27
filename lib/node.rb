require 'pry'

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

  # need to refactor
  def insert(str, position = 0)
    fail 'Second argument must be an integer' unless position.is_a?(Fixnum)

    @valid_word = true if str.length == position

    return if str[position].nil?

    letter = str[position]

    links[letter] = Node.new(str[0..position]) if links[letter].nil?

    links[letter].insert(str, position + 1)
  end

  def search(str, position = 0)
    letter = str[position]

    return links[letter] if end_of_string?(str, position)

    links[letter].search(str, position + 1)
  end

  def end_of_string?(str, position)
    str.length == position + 1
  end

  def links_exist(cur_links, letter)
    cur_links[letter].links != {}
  end

  # need to refactor
  def find_valid_words(cur_links)
    matches = []

    cur_links.keys.each do |k|
      matches.push(cur_links[k].value, cur_links[k].select_count) if cur_links[k].valid_word

      matches << find_valid_words(cur_links[k].links) if links_exist(cur_links, k)
    end

    matches.flatten
  end

  def count_valid_words
    links.to_s.scan("@valid_word=true").count
  end

  def suggest(str)
    match = search(str)
    suggestions = find_valid_words(match.links)
    add_current_word(match, suggestions) if match.valid_word
    suggestions = slice_into_pairs(suggestions)
    suggestions = sort_and_collect_suggestions(suggestions)
  end

  def add_current_word(match, suggestions)
    suggestions.concat( [match.value, match.select_count] )
  end

  def slice_into_pairs(arr)
    arr.each_slice(2).to_a
  end

  def sort_and_collect_suggestions(list)
    list = list.sort_by { |name, count| count }.reverse
    list.collect { |idx| idx[0] }
  end

  def select(selection)
    search(selection).select_count += 1
  end
end
