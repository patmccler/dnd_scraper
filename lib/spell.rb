# This is responsible to be the blueprint for a spell
# A class has many spells, and spells can belong to many classes.

class Spell
  attr_reader :name, :level, :link, :school

  attr_accessor :cast_time, :range, :components,
                :duration, :description, :ritual, :concentration

  extend Memoable::ClassMethods
  extend Findable::ClassMethods
  include Memoable::InstanceMethods

  LEVELS = (0..9).freeze

  class << self
    def find_or_create(name, level, link)
      find_by_name(name) || new(name, level, link)
    end

    def valid_level?(level)
      level.to_i unless level.is_a? Integer
      LEVELS.cover?(level)
    end

    def level_from_str(level)
      level = 0 if level.casecmp("cantrip").zero?
      level = level.scan(/\-?\d+/)[0] if level.is_a?(String)
      level = level.to_i if level.is_a? String
      level if LEVELS.cover?(level)
    end
  end

  def initialize(name, level, link)
    @name = name
    self.level = level
    @link = link
    save
  end

  def school=(school_name)
    @school = School.find_or_create(school_name)
  end

  def level=(input)
    @level = input.scan(/\d+/)[0].to_i if input.is_a?(String)
    @level = input if input.is_a?(Integer)
  end

  def update_casting_info(cast_time: nil, range: nil, components: nil,
                          duration: nil, concentration: nil)
    self.cast_time = cast_time if cast_time
    self.range = range if range
    self.components = components if components
    self.duration = duration if duration
    self.concentration = concentration unless concentration.nil?
  end

  def update_type_info(ritual: nil, school: nil)
    self.ritual = ritual unless ritual.nil?
    self.school = school if school
  end

  def ritual?
    @ritual
  end

  def concentration?
    @concentration
  end
end
