# This is responsible to be the blueprint for a spell
# A class has many spells, and spells can belong to many classes.

class Spell
  attr_reader :name, :level

  extend Memoable::ClassMethods
  extend Findable::ClassMethods
  include Memoable::InstanceMethods


  def initialize(name, level, link)
    @name = name
    @level = level
    @link = link
    save
  end

  def self.find_or_create(name, level, link)
    find_by_name(name) || new(name, level, link)
  end
end
