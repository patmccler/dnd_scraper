# Represents a school of magic
# Each school has many spells
# Spells belong to one specific school

class School
  attr_reader :name

  extend Memoable::ClassMethods
  extend Findable::ClassMethods
  include Memoable::InstanceMethods

  def initialize(name)
    @name = name
    save
  end

  def spells
    Spell.all.select { |s| s.school == self }
  end

  def self.find_or_create(name)
    find_by_name(name) || new(name)
  end
end
