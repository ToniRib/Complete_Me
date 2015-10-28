# Complete Me
## Turing Module 1: Project 4 (Echo)

### Overview

This project simulates the autocomplete functionality that most of us are familiar with today. It's basic design is a [Trie data structure](https://en.wikipedia.org/wiki/Trie) which uses branching nodes to create paths to words. Words can be added to the 'dictionary' one at a time or in bulk. Suggestions for a particular string are then found by traversing the tree to that the subtree that contains the search string and then locating any valid words (words that were added by the user) below that node on the tree.

In order to mimic autocompletion even more, words can be 'selected' so that words with more selections appear at the beginning of the array of suggestions.

The main classes for this project are `CompleteMe` (the Trie class) and `Node`.

### Available Trie Methods

* __insert(word)__ - inserts the given word into the Trie
* __populate(list)__ - mass inserts many words into the Trie. The list can either be a string separated by new line characters (such as `"apple\nbanana\npear"`) or an array of strings
* __suggest(string)__ - returns an array of suggestions that begin with the given string. If the string is a word itself it will also be returned. Returns an error if no strings begin with the suggestion.
* __suggest_substring(string)__ - returns an array of suggestions that contain the substring in any part of the word. Returns an error if no strings contain the suggestion.
* __count__ - returns the number of valid words in the Trie
* __select(substring, string)__ - allows the user to 'promote' the given string, thus ensuring it is at the beginning of the array of suggestions. Strings can be selected more than once, and the array of suggestions will be output based on the number of selections each string has. At this point, substring is ignored. Select returns an error if the string is not found in the Trie.

#### Examples

The following is an example as run with [pry](https://github.com/pry/pry) from the command line in the base directory of the project:

```
[1] pry(main)> require './lib/complete_me.rb'
=> true

[2] pry(main)> completion = CompleteMe.new
=> #<CompleteMe:0x007fe4fc9065d0
 @center=
  #<Node:0x007fe4fc9064b8
   @links={},
   @select_count=0,
   @valid_word=false,
   @value="">,
 @count=0>

[3] pry(main)> completion.insert("pizza")
=> 1

[4] pry(main)> completion.count
=> 1

[5] pry(main)> completion.suggest("piz")
=> ["pizza"]

[6] pry(main)> dictionary = File.read('/usr/share/dict/words')
=> < output omitted for brevity >

[7] pry(main)> completion.populate(dictionary)
=> 235886

[8] pry(main)> completion.count
=> 235886

[9] pry(main)> completion.suggest('piz')
=> ["pize", "pizzle", "pizzicato", "pizzeria", "pizza"]

[10] pry(main)> completion.suggest_substring('piz')
=> ["unlycanthropize",
 "syncopize",
 "stylopized",
 "stylopization",
 "spizzerinctum",
 < part of array omitted for brevity >
 "papize",
 "pize",
 "pizzle",
 "pizzicato",
 "pizzeria",
 "pizza"]

[11] pry(main)> completion.select('piz', 'pizzeria')
=> 1

[12] pry(main)> completion.suggest('piz')
=> ["pizzeria", "pizzicato", "pizzle", "pize", "pizza"]
```

### Denver Address Load & Suggestions

The project contains a separate file `load_addresses.rb` which allows for the loading of the [database of Denver county addresses](http://data.denvergov.org/dataset/city-and-county-of-denver-addresses) as a csv file. The file is already stored in the addresses directory. The file contains a few examples of suggestion and selection and can be run as is from the command line by performing the following:

```
$ ruby lib/load_addresses.rb
Loading database of Denver addresses...
Populating Trie with Denver addresses...
Falling Rock Tap House:
1919 Blake St
Promoting Turing
10 other 1510 addresses:
1510 Blake St
1510 S Josephine St
15106 E 50th Way
15101 E Mitchell Pl
15101 E 50th Ave
15101 E Bolling Dr
15103 E Kelly Pl
15103 E Andrews Dr
15102 E Andrews Dr
15102 E Kelly Pl
15104 E Maxwell Pl
```

Additionally, the file could be required while in a pry session from the command line to allow for dynamic searching of the Trie:

```
require './lib/load_addresses.rb'
completion = CompleteMe.new
loader = LoadAddresses.new

full_addresses = loader.load("./addresses/addresses.csv")

completion.populate(full_addresses)
```

After running the `populate` command, any of the other `CompleteMe` methods can be used.

### Shoes GUI

The project comes with a graphical user interface built with [Shoes](http://shoesrb.com/) that can be run if you have the Shoes software downloaded.

If you have Shoes, you can open the file `lib/shoes_app.rb` from the Shoes program to launch the GUI. The GUI allows you to type in a string and see the resulting matches. It does not contain the `select` functionality at this time.

![Image of Shoes App](https://github.com/ToniRib/Complete_Me/blob/master/images/shoes_app.png?raw=true =350x)

### Test Suite

The Node and CompleteMe classes each have a corresponding testing file written with [minitest](https://github.com/seattlerb/minitest) which can be run from the terminal using mrspec:

```
$ mrspec spec/node_test.rb

Node
  fixum returns false if input is a string
  can insert two multiletter words
  only one node can be selected at a time
  node can be initialized with a single letter value
  two nodes can be selected sequentially
  returns error if search string does not exist
  counts returns total number of valid words
  empty node has no valid words
  node starts with a selection count of zero
  returns false if link exist for specific letter
  fixnum returns true if input is an integer
  fixum returns false if input is an array
  finds node with given value
  < other tests omitted for brevity >

Failures:

Finished in 0.00573 seconds (files took 0.18926 seconds to load)
38 examples, 0 failures
```

You can also run all the tests at the same time by running the `mrspec` command from the terminal in the project's base directory.

#### Dependencies

Must have the [mrspec gem](https://github.com/JoshCheek/mrspec) and [minitest gem](https://github.com/seattlerb/minitest) installed.

Alternatively, you could run the tests without using mrspec by using the following command structure:

```
$ ruby spec/node_test.rb
Run options: --seed 54367

# Running:

......................................

Fabulous run in 0.002886s, 13167.7706 runs/s, 22523.8181 assertions/s.

38 runs, 65 assertions, 0 failures, 0 errors, 0 skips
```
