# This is responsible to be the blueprint for a spell
# A class has many spells, and spells can belong to many classes.

class Spell
  attr_reader :name, :level

  def initialize(name, level, link)
    @name = name
    @level = level
    @link = link
  end

  def self.find_or_create(name, level, link)
    #todo make this also find!
    Spell.new(name, level, link)
  end
end
