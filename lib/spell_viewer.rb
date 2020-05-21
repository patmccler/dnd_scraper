require "io/console"

class SpellViewer
  def initialize(spell)
    @line_length = IO.console.winsize[1]
    puts @line_length
    @spell = spell
    SpellScraper.scrape_spell_info(spell) unless info_complete?(spell)
  end

  # Checks if spell has detailed info or not
  def info_complete?(spell)
    spell.cast_time && spell.range && spell.components &&
      spell.duration && spell.ritual && spell.concentration
  end

  def print_spell
    print_header
    print_casting_details
    print_description
    # return name to keep expect string value on call
    @spell.name
  end

  def print_header
    puts "#" * @line_length
    print_line_centered(@spell.name, bord: "#")
    print_sub_text
    puts "#" * @line_length
  end

  def print_sub_text
    text = level_str(@spell.level) + @spell.type + cantrip_str(@spell.level)
    print_line_centered("- #{text} -", bord: "#")
  end

  def print_casting_details
    print_line_centered(cast_time_str, bord: "|")
    print_line_centered(range_str, bord: "|")
    print_line_centered(components_str, bord: "|")
    print_line_centered(duration_str, bord: "|")
    print_horizontal_rule()
  end

  def print_description
    print_multiline_center(@spell.description, pad: @line_length / 8)
  end

  # Helpers for printing
  def level_str(level)
    level.positive? ? "#{level.to_s + ordinal(level)} level " : ""
  end

  def cantrip_str(level)
    level.zero? ? " Cantrip" : ""
  end

  def cast_time_str
    "Cast Time: #{@spell.cast_time || 'unknown'}"
  end

  def range_str
    "Range: #{@spell.range || 'unknown'}"
  end

  def components_str
    "Components: #{@spell.components || 'unknown'}"
  end

  def duration_str
    "Duration: #{concentration_str + @spell.duration}"
  end

  def concentration_str
    @spell.concentration? ? "Concentration, " : ""
  end

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

  def ordinal(num)
    case num % 10
    when 1 then "st"
    when 2 then "nd"
    when 3 then "rd"
    else "th"
    end
  end
end
