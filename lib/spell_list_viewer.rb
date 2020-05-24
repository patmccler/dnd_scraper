class SpellListViewer
  def initialize(spell_list)
    @printer = Printer.new
    @spells = spell_list
  end

  def print_spells_by_level(level = nil)
    spells_h = @spells.group_by(&:level)

    spells_h = { level => spells_h[level] } if level
    if level && spells_h[level].nil?
      @printer.print_line_centered "No spells known at level #{level}"
      return
    end

    spells_h.each do |spell_level, spells|
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
