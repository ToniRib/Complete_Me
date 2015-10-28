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

puts "Jeff's house:"
puts completion.suggest('1650 N Pop')

puts "Promoting Toni's old apartment"
completion.select('1164', '1164 S Acoma St Unit 390')

puts "Units in the 390 - 399 range at Toni's old apartment complex:"
puts completion.suggest('1164 S Acoma St Unit 39')
