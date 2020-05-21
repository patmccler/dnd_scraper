class SpellViewer
  LINE_LENGTH = 40

  def initialize(spell)
    @spell = spell
  end

  def print_spell
    print_header
    print_casting_details
    # print_description
  end

  def print_header
    puts "#" * LINE_LENGTH
    print_center(@spell.name, "#")
    print_sub_text
    puts "#" * LINE_LENGTH
  end

  def print_sub_text
    text = level_text(@spell.level) + @spell.type + cantrip_text(@spell.level)
    print_center("- #{text} -", "#")
  end

  def print_casting_details
    indent = 3
    print_indent("Cast Time: #{@spell.cast_time || 'unknown'}", indent)
    print_indent("Range: #{@spell.range || 'unknown'}", indent)
    print_indent("Components: #{@spell.components || 'unknown'}", indent)
    print_indent("Duration: #{@spell.duration || 'unknown'}", indent)
  end

  def print_center(str, border = "", line_length = LINE_LENGTH)
    unless line_length < str.length
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

  def level_text(level)
    level.positive? ? "#{level.to_s + ordinal(level)} level " : ""
  end

  def cantrip_text(level)
    level.zero? ? " Cantrip" : ""
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
