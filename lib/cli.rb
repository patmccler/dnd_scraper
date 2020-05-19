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
    promt_for_class_choice
  end

  def classes
    Klass.all
  end

  def welcome
    puts "Hello, welcome to this DND Spell lookup app!"
    puts "Spells have both a level and a school,"
    puts "and can be learned by one or more classes"
  end

  def promt_for_class_choice
    puts "Enter a class number or name from the list"
    puts "to see which spells that class has available."
    classes.each_with_index do |klass, i|
      puts "#{i + 1}. #{klass.name}"
    end

    input = user_input
    until input.casecmp("exit").zero?
      puts "Start of until loop"
      klass = Klass.find_by_name_or_number(input) #TODO
      if klass
        # puts "#{klass.name} chosen!"
        prompt_for_klass_spell_choice(klass)
      else
        puts "I'm sorry, I didn't quite get that. Try again?"
      end
      input = user_input
    end
  end

  def prompt_for_klass_spell_choice(klass)
    puts "You have chosen #{klass.name} spells."
    puts klass.spells.map(&:name)
  end

  def user_input
    gets.chomp
  end
end
