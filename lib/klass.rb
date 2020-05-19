# This is responsible for the blueprint of my character class from DnD 5th edition
# This will never use nokogiri
# This will never use puts
# Store all of my class instance data

class Klass
  attr_reader :name
  extend Memoable::ClassMethods
  include Memoable::InstanceMethods

  def initialize(name)
    @name = name
    save
  end

  class << self
    # called first time, scrapes for class names and makes those classes
    # memoable looks for this when first calling .all
    def generate_all
      class_names = Scraper.scrape_classes
      class_names.map { |class_name| Klass.new(class_name) }
    end

    def find_by_name(name)
      all.find { |klass| klass.name.casecmp(name).zero? }
    end

    def find_by_number(num)
      all[num.to_i - 1] if (1..count).cover?(num.to_i)
    end

    def find_by_name_or_number(input)
      find_by_name(input) || find_by_number(input)
    end
  end

  def spells
    ["fireball"]
  end
end
