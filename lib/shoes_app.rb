Shoes.app do
  background "#1fb2cc"

  stack(margin: 12) do
    para "Enter string to get suggestions:"
    flow do
      edit_line
      @push = button "search"
    end
    @s = para 'no suggestions yet...'

    @push.click {
      @s.replace 'clicked!'
    }
  end
end
