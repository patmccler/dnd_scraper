require "IO/console"
class Printer
  attr_reader :line_length

  TABSIZE = 8

  def initialize
    @line_length = IO.console.winsize[1]
  end

  # Takes a string or strings
  # Prints a full width box of 'chars' around those strings centered
  # max width of console
  def print_box(strings, char = "#")
    strings = [strings] unless strings.is_a? Array
    print_horizontal_rule(char)
    strings.each { |s| print_line_centered(s, border: char) }
    print_horizontal_rule(char)
  end

  # prints enough of chars to go across the screen
  def print_horizontal_rule(char = "—")
    puts char[0] * @line_length
  end

  # takes a single string
  # prints that string, centered in the console,
  # with 'pad' spaces around it and 'border' at the edge of the console
  def print_line_centered(str, border: "", pad: 0)
    last = str.split(" ").inject("") do |current_line, word|
      # + 1 for space at end
      if next_line?(str, current_line, word, pad, border)
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
  ####
  # Avg not max, but some % of it??

  # Takes a single long string
  # splits it on new lines, and prints each of those 'sentances' centered
  def print_multiline_center(str, pad: 0)
    # Each paragraph
    str.split("\n").each do |sentance|
      # Each sentance
      print_line_centered(sentance, pad: pad)
    end
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

private

  def print_center(str, border = "")
    unless @line_length <= curr_line_size(str, "", 0, border)
      pad, extra_space = padding(str.length, border.length)
      str = border + (" " * pad) + str + (" " * (pad + extra_space)) + border
    end
    puts str
  end

  # finds the empty space between a string that needs printing
  # with any "border" string length
  def padding(str_length, border_length)
    (@line_length - str_length - 2 * border_length).divmod(2)
  end

  def curr_line_size(curr_line, word, padding, border)
    curr_line.size + word.size + 2 * padding + border.size * 2
  end

  # determines if a line will exceed the given space, or otherwise need to wrap
  def next_line?(str, current_line, next_word, pad, border)
    available_space = available_space(pad, border)
    min_lines = (str.length.to_f / available_space).ceil
    avg_length = avg_length(str, min_lines, available_space)
    leeway = (available_space - avg_length) * 0.5

    # true means line will be too long, time to start the next line
    ((current_line.size + next_word.size + 1) > (avg_length + leeway))
  end

  def avg_length(str, lines, space)
    avg = str.length.to_f / lines
    # if too close to even fit, use an extra line
    avg = str.length.to_f / (lines + 1) if avg / space > 0.9
    avg
  end

  def available_space(pad = 0, border = "")
    @line_length - (2 * (pad + border.size))
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
end
