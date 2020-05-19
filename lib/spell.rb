# This is responsible to be the blueprint for a spell
# A class has many spells, and spells can belong to many classes.

class Spell
  attr_reader :name, :level

  def initialize(name, level)
    @name = name
    @level = level
  end
end
