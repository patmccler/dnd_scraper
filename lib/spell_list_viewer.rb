require "io/console"

class SpellListViewer
  include Printer

  def initialize(spell_list)
    @line_length = IO.console.winsize[1]
    @spells = spell_list
  end

  def print_spells_by_level(level = nil)
    spells_h = @spells.each_with_object({}) do |spell, obj|
      obj[spell.level] ||= []
      obj[spell.level] << spell
    end

    spells_h = { level => spells_h[level] } if level

    spells_h.each do |spell_level, spells|
      print_spell_group(title: "Level #{spell_level} Spells: #{spells.count}",
                        spells: spells)
    end
    puts
  end

  def print_spell_group(title:, spells:)
    print_box(title, "+")
    print_table(spells.map(&:name))
    # puts spells.map(&:name)
    puts
  end
end
