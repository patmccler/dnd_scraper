module Printer
  TABSIZE = 8
  # TODO: organize public vs private

  def print_center(str, border = "")
    unless @line_length <= str.length
      pad, r = padding(str.length, border.length)
      str = border + (" " * pad) + str + (" " * (pad + r)) + border
    end
    puts str
  end

  # finds the empty space between a string that needs printing
  # with any "border" string
  # for a given line length
  def padding(str_length, border_length)
    (@line_length - str_length - 2 * border_length).divmod(2)
  end

  def print_box(strings, char = "#")
    strings = [strings] unless strings.is_a? Array
    print_horizontal_rule(char)
    strings.each { |s| print_line_centered(s, border: char) }
    print_horizontal_rule(char)

  end

  def print_indent(str, indent)
    puts (" " * indent) + str
  end

  def print_horizontal_rule(char = "—")
    puts char[0] * @line_length
  end

  def print_multiline_center(str, pad: 0)
    # Each paragraph
    str.split("\n").each do |sent|
      # Each sentance
      print_line_centered(sent, pad: pad)
    end
  end

  def print_line_centered(str, border: "", pad: 0)
    last = str.split(" ").inject("") do |current_line, word|
      if curr_line_size(current_line, word, pad, border) > @line_length
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

  # prints a table with the given number of columns 'col'
  # by default will print as many columns as possible
  # will try to do as many possible columns up to the num given
  def print_table(str_arr, cols: nil)
    longest_word_tabs = tabs_for_largest_str(str_arr)
    cols = max_columns(longest_word_tabs) if cols.nil?
    col_tabs = (@line_length / cols) / TABSIZE

    # 1 or Less columns, just print out in center
    if cols <= 1
      str_arr.each { |str| print_line_centered(str) }
    elsif longest_word_tabs > col_tabs
      # fall back to less columns when it doesnt fit
      print_table(str_arr, cols: (cols - 1))
    else
      print_table_print(str_arr, col_tabs, cols)
    end
  end

  def max_columns(word_tabs)
    (@line_length / TABSIZE) / word_tabs
  end

  def tabs_for_largest_str(str_arr)
    str_arr.map(&:size).max / TABSIZE + 1
  end

  def print_table_print(str_arr, col_tabs, cols)
    str_arr.each_with_index do |str, i|
      str = pad_with_space(str, col_tabs)

      # each line gets 'col' elements
      str += "\n" if ((i + 1) % cols).zero?
      print str
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
