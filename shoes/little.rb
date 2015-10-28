require_relative 'complete_me'

Shoes.app do
  background "#1fb2cc"

  stack(margin: 12) do
    para "Enter string to get suggestions:"
    flow do
      edit_line
      @push = button "search"
    end
    @suggestions = para 'no suggestions yet...'
  end

  @push.click {
    @note.replace 'clicked!'
  }
end
