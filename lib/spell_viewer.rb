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
    if line_length < str.length
      puts str
    else
      pad, r = (line_length - str.length - 2 * border.length).divmod(2)
      puts border + (" " * pad) + str + (" " * (pad + r)) + border
    end
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
