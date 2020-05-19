# Represents a class knowing a particular spell

class KlassSpell
  attr_reader :klass, :spell
  def initialize(klass, spell)
    @klass = klass
    @spell = spell
  end
end