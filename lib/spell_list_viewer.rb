class SpellListViewer
  include Printer

  def initialize(spell_list)
    @spells = spell_list
  end

  def print_spells_by(sort)
    puts spells.map(&:name)
  end

end