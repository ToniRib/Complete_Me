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
    @valid_word = true if str.length == position

    return if str[position].nil?

    letter = str[position]

    if links[letter].nil?
      links[letter] = Node.new(str[0..position])
    end

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
      matches.push(cur_links[k].value) if cur_links[k].valid_word

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
    suggestions << match.value if match.valid_word
    suggestions
  end
end
