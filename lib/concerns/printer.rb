module Printer
  def print_center(str, border = "", line_length = @line_length)
    unless line_length <= str.length
      pad, r = padding(line_length, str.length, border.length)
      str = border + (" " * pad) + str + (" " * (pad + r)) + border
    end
    puts str
  end

  # finds the empty space between a string that needs printing
  # with any "border" string
  # for a given line length
  def padding(line_length, str_length, border_length)
    (line_length - str_length - 2 * border_length).divmod(2)
  end

  def print_indent(str, indent)
    puts (" " * indent) + str
  end

  def print_horizontal_rule(line_length = @line_length)
    puts "—" * line_length
  end

  def print_multiline_center(str, pad: 0, line_length: @line_length)
    # Each paragraph
    str.split("\n").each do |sent|
      # Each sentance
      print_line_centered(sent, pad: pad, line_length: line_length)
    end
  end

  def print_line_centered(str, bord: "", pad: 0, line_length: @line_length)
    last = str.split(" ").inject("") do |curr_line, word|
      # binding.pry
      if curr_line_size(curr_line, word, pad, bord) > line_length
        print_center(curr_line, bord)
        ""
      else
        curr_line.empty? ? word : "#{curr_line} #{word}"
      end
    end
    print_center(last, bord)
  end

  def curr_line_size(curr_line, word, padding, border)
    curr_line.size + word.size + 2 * padding + border.size
  end

  def print_table(item_arr, columns: 1, line_length: @line_lengh)

  end

  def ordinal(num)
    case num % 10
    when 1 then "st"
    when 2 then "nd"
    when 3 then "rd"
    else "th"
    end
  end
end
