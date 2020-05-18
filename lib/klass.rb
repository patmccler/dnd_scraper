# This is responsible for the blueprint of my character class from DnD 5th edition
# This will never use nokogiri
# This will never use puts
# Store all of my class instance data

class Klass
  attr_reader :name

  def initialize(name)
    @name = name
    tap(&:save)
  end

  def save
    self.class.all << self
  end
  class << self
    def all
      @all ||= generate_classes
    end

    # called first time, scrapes for class names and makes those classes
    def generate_classes
      @all = []
      class_names = Scraper.scrape_classes
      class_names.map { |class_name| Klass.new(class_name) }
    end
  end
end
