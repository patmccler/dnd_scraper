class SpellViewer
  LINE_LENGTH = 40

  def initialize(spell)
    @spell = spell
  end

  def print_spell
    print_name
    print_sub_text
    # print_casting_details
    # print_description
  end

  def print_name
    puts "#{'#'*LINE_LENGTH}"
    puts "# #{@spell.name}#{' ' * (LINE_LENGTH - 4 - @spell.name.size)} #"
    puts "#{'#'*LINE_LENGTH}"
  end

  def print_sub_text
    text = "- #{@spell.level.to_s + ordinal(@spell.level)}"\
         " level #{@spell.type} -"
    print_center(text)

  end

  def print_center(str, line_length = LINE_LENGTH)
    if line_length < str.length
      puts str
    else
      diff = line_length - str.length
      diff += 1 if diff.odd?
      puts (" " * (diff / 2)) + str + ("  "* (diff / 2))
    end
  end

  def ordinal(num)
    case num % 100
    when 11, 12, 13 then 'th'
    else
      case num % 10
      when 1 then 'st'
      when 2 then 'nd'
      when 3 then 'rd'
      else 'th'
      end
    end
  end
end
