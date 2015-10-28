require 'csv'
require_relative 'complete_me'

# class to load Denver addresses from csv file
class LoadAddresses
  def load(file)
    full_addresses = []

    CSV.foreach(file) do |row|
      full_addresses.push(row.last)
    end

    full_addresses
  end
end

completion = CompleteMe.new
loader = LoadAddresses.new

puts 'Loading database of Denver addresses...'
full_addresses = loader.load("./addresses/addresses.csv")

puts 'Populating Trie with Denver addresses...'
completion.populate(full_addresses)

puts "Falling Rock Tap House:"
puts completion.suggest('1919 Blake')

puts "Promoting Turing"
completion.select('1510', '1510 Blake St')

puts "10 other 1510 addresses:"
puts completion.suggest('1510')[0..10]
