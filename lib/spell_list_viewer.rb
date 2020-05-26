class SpellListViewer
  def initialize(spell_list)
    @printer = Printer.new
    @spells = spell_list
  end

  def print_spells(level = nil)
    if level && @spells.empty?
      no_spells_at_level_msg(level)
    elsif !level && @spells.empty?
      no_spells_msg
    elsif print_spells_by_level(@spells)
    end
    puts
  end

private

  def no_spells_at_level_msg(level)
    @printer.print_line_centered("No spells known at level #{level}")
  end

  def no_spells_msg
    msg = "No spells known yet! Look at some classes to learn more."
    @printer.print_line_centered(msg)
  end

  def print_spells_by_level(spells_to_print)
    spells_to_print = spells_to_print.group_by(&:level)
    spells_to_print.each do |spell_level, spells|
      print_spell_group(level_title(spell_level, spells.count), spells)
    end
    puts
  end

  def level_title(level, spell_count)
    "Level #{level} Spells: #{spell_count}"
  end

  def print_spell_group(title, spells)
    @printer.print_box(title, "+")
    @printer.print_table(spells.map(&:name))
    puts
  end
end
