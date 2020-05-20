
class SpellViewer

  def initialize(spell)
    @spell = spell
  end

  def print_spell
    puts "Name: #{@spell.name}, Level: #{@spell.level}, Type: #{@spell.type}"
  end"

end