Shoes.setup do
  require './complete_me'
end

Shoes.app(width:500, height: 500) do
  background "#1fb2cc"

  stack(margin: 12) do
    title "CompleteMe"

    para "Enter string to get suggestions:"

    flow do
      @e = edit_line width: 100
      @push_start = button "search (starts with)"
      @push_all = button "search (includes)"
    end

    @s = para 'no suggestions yet...'

    @push_start.click {
      @matches = @completion.suggest(@e.text)
      @s.replace @matches.join("\n")
    }

    @push_all.click {
      @matches = @completion.suggest_substring(@e.text)
      @s.replace @matches.join("\n")
    }
  end

  dictionary = File.read('/usr/share/dict/words')
  @completion = CompleteMe.new
  @completion.populate(dictionary)
end
