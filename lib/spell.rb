# This is responsible to be the blueprint for a spell
# A class has many spells, and spells can belong to many classes.

class Spell
  attr_reader :name, :level

  attr_accessor :type

  extend Memoable::ClassMethods
  extend Findable::ClassMethods
  include Memoable::InstanceMethods

  LEVELS = (0..9).freeze

  def initialize(name, level, link)
    @name = name
    self.level = level
    @link = link
    @type = ""
    save
  end

  def level=(input)
    @level = input.scan(/\d+/)[0].to_i
  end

  def self.find_or_create(name, level, link)
    find_by_name(name) || new(name, level, link)
  end

  def self.valid_level?(level)
    LEVELS.cover?(level)
  end
end
