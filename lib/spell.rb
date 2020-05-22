# This is responsible to be the blueprint for a spell
# A class has many spells, and spells can belong to many classes.

class Spell
  attr_reader :name, :level, :link

  attr_accessor :type, :cast_time, :range, :components,
                :duration, :description, :ritual, :concentration

  extend Memoable::ClassMethods
  extend Findable::ClassMethods
  include Memoable::InstanceMethods

  LEVELS = (0..9).freeze

  def initialize(name, level, link)
    @name = name
    self.level = level
    @link = link
    @type = "TEMP TYPE"
    save
  end

  def level=(input)
    @level = input.scan(/\d+/)[0].to_i if input.is_a?(String)
    @level = input if input.is_a?(Integer)
  end

  def update_casting_info(cast_time: nil, range: nil, components: nil,
                          duration: nil, concentration: nil)
    @cast_time = cast_time if cast_time
    @range = range if range
    @components = components if components
    @duration = duration if duration
    @concentration = concentration unless concentration.nil?
  end

  def update_type_info(ritual: nil, type: nil)
    @ritual = ritual unless ritual.nil?
    @type = type if type
  end

  def self.find_or_create(name, level, link)
    find_by_name(name) || new(name, level, link)
  end

  def self.valid_level?(level)
    level.to_i unless level.is_a? Integer
    LEVELS.cover?(level)
  end

  def ritual?
    @ritual
  end

  def concentration?
    @concentration
  end
end
