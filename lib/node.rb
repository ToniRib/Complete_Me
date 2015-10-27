require 'pry'

# Class for each node of the Trie
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

    links[letter] = Node.new(str[0..pos]) if link_does_not_exist(letter)

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

    links[letter].search(str, pos + 1)
  end

  def end_of_string?(str, pos)
    str.length == pos + 1
  end

  def find_words(cur_links)
    matches = []

    cur_links.keys.each do |k|
      matches.push(value_count_pair(cur_links, k)) if cur_links[k].valid_word
      matches << find_words(cur_links[k].links) if links_exist(cur_links, k)
    end

    matches.flatten
  end

  def links_exist(cur_links, letter)
    !cur_links[letter].links.empty?
  end

  def value_count_pair(links, k)
    [links[k].value, links[k].select_count]
  end

  def count_valid_words
    links.to_s.scan('@valid_word=true').count
  end

  def suggest(str)
    match = search(str)
    suggestions = find_words(match.links)
    add_current_word(match, suggestions) if match.valid_word
    suggestions = slice_into_pairs(suggestions)
    sort_and_collect_suggestions(suggestions)
  end

  def add_current_word(match, suggestions)
    suggestions.concat([match.value, match.select_count])
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
