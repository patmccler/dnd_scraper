# Represents a class knowing a particular spell

class KlassSpell
  attr_reader :klass, :spell

  extend Memoable::ClassMethods
  include Memoable::InstanceMethods

  def initialize(klass, spell)
    @klass = klass
    @spell = spell
    save
  end

  def self.create_many_from_spell_array(klass, spell_array)
    spell_array.map do |spell|
      new(klass, spell)
    end
  end
end