# Complete Me
## Turing Module 1: Project 4 (Echo)

### Overview

This project simulates the autocomplete functionality that most of us are familiar with today. It's basic design is a [Trie data structure](https://en.wikipedia.org/wiki/Trie) which uses branching nodes to create paths to words. Words can be added to the 'dictionary' one at a time or in bulk. Suggestions for a particular string are then found by traversing the tree to that the subtree that contains the search string and then locating any valid words (words that were added by the user) below that node on the tree.

In order to mimic autocompletion even more, words can be 'selected' so that words with more selections appear at the beginning of the array of suggestions.

The main classes for this project are `CompleteMe` (the Trie class) and `Node`.

### Available Trie Methods

* __insert(word)__ - some info here
