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
    prompt_for_class_choice
  end

  def classes
    Klass.all
  end

  def welcome
    puts "Hello, welcome to this DND Spell lookup app!"
    puts "Spells have both a level and a school,"
    puts "and can be learned by one or more classes"
  end

  def prompt_for_class_choice
    puts "Enter a class number or name from the list"
    puts "to see which spells that class has available."
    classes.each_with_index do |klass, i|
      puts "#{i + 1}. #{klass.name}"
    end

    input = user_input
    until equals_exit(input)
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

  def equals_exit(input)
    input.casecmp("exit").zero?
  end


  def prompt_for_klass_spell_choice(klass)
    spells = klass.spells
    name = klass.name
    if spells.empty?
      print "Unfortunately, it doesn't look like #{name}"
      print " can learn any spells!\n"
    else
      puts "#{name}s have #{spells.count} spells."
      puts "Enter a level 0 - 9 to see spells of that level."
      puts "Enter 'all' to see them all at once."
      puts "Enter a spell name to see that spell's info."
      input = user_input

      until equals_exit(input)
        ## Check for 0-9, or spell name here


      end

    end
  end

  def user_input
    gets.chomp
  end
end
