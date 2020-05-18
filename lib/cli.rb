# This class is responsible for communication with the user.
# This is where I will use "puts" alog
# This will neer use nokogiri
# This will have to invoce Scraper

class Cli

  def initialize
    # build_classes
  end

  def call
    welcome
    spell_by_class
  end

  def classes
    @classes ||= generate_classes
  end

  def generate_classes
    class_names = Scraper.scrape_classes
    class_names.map { |class_name| Klass.new(class_name) }
  end

  def welcome
    puts "Hello, welcome to this DND Spell lookup app!"
    puts "Spells have both a level and a school, and can be learned by one or more classes"
  end

  def spell_by_class

    puts "Enter a class from the list to see which spells that class knows."
    puts classes.map(&:name)
  end
end
