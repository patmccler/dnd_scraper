module Printer
  TABSIZE = 8
  # TODO: organize public vs private

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

  def print_line_centered(str, border: "", pad: 0, line_length: @line_length)
    last = str.split(" ").inject("") do |current_line, word|
      if curr_line_size(current_line, word, pad, border) > line_length
        # if adding the word would make the line too long,
        # print the line as is and start the next line with the word
        print_center(current_line, border)
        word
      else
        current_line.empty? ? word : "#{current_line} #{word}"
      end
    end
    print_center(last, border)
  end

  def curr_line_size(curr_line, word, padding, border)
    curr_line.size + word.size + 2 * padding + border.size
  end

  def print_table(str_arr, cols: 1, line_length: @line_length)
    max_tabs = str_arr.max_by(&:size).size / TABSIZE + 1

    cols = line_length / TABSIZE / max_tabs if cols == "max"

    col_width = (line_length / cols) / TABSIZE




    if max_tabs > col_width || cols == 1
      if cols <= 1
        # cant have 0 columns, just center the lines
        str_arr.each { |str| print_line_centered(str) }
      else
        # fall back to less columns when it doesnt fit
        print_table(str_arr, cols: (cols - 1), line_length: line_length)
      end
    else
      str_arr.each_with_index do |str, i|
        str = pad_with_space(str, col_width)
        str += "\n" if ((i + 1) % cols).zero?
        print str
      end
    end
  end

  # fills string with tabs and spaces to make a table
  # str size gauranteed to be small than desired length
  # desired length is in tabs
  def pad_with_space(str, desired_length)
    str_tabs = str.size / TABSIZE
    str + "\t" * (desired_length - str_tabs)
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
