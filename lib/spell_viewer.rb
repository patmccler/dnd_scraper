require "io/console"

class SpellViewer
  def initialize(spell)
    @printer = Printer.new
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
    subtext = level_str + @spell.type + cantrip_str + ritual_str
    @printer.print_box([@spell.name, "- #{subtext} -"])
  end

  def sub_text_str
    text = level_str + @spell.type + cantrip_str +
           ritual_str
    "- #{text} -"
  end

  def print_casting_details
    @printer.print_line_centered(cast_time_str, border: "|")
    @printer.print_line_centered(range_str, border: "|")
    @printer.print_line_centered(components_str, border: "|")
    @printer.print_line_centered(duration_str, border: "|")
    @printer.print_horizontal_rule
  end

  def print_description
    line_length = @printer.line_length
    @printer.print_multiline_center(@spell.description, pad: line_length / 8)
  end

  # Helpers for printing
  def level_str
    level = @spell.level
    level.positive? ? "#{level.to_s + ordinal(level)} level " : ""
  end

  def cantrip_str
    @spell.level.zero? ? " Cantrip" : ""
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

  def ritual_str
    @spell.ritual? ? " (ritual)" : ""
  end

  def concentration_str
    @spell.concentration? ? "Concentration, " : ""
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
