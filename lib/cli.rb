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

    until equals_exit(input = user_input)
      puts "Start of until loop"
      klass = Klass.find_by_name_or_number(input)
      if klass
        # puts "#{klass.name} chosen!"
        prompt_for_klass_spell_choice(klass)
      else
        puts "I'm sorry, I didn't quite get that. Try again?"
      end
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
      class_spell_prompt(name, spells.count)
      until equals_exit(input = user_input)
        if (0..9).cover? int_from_string(input)
          print_spells_at_level(spells, int_from_string(input))
        elsif input.eql?("all")
          print_spells(spells)
        else
          # TODO!
          puts "I couldnt find that spell"
        end
        class_spell_prompt(name, spells.count)
      end
    end
  end

  def class_spell_prompt(name, spell_count)
    puts "#{name}s have #{spell_count} spells."
    puts "Enter a level 0 - 9 to see spells of that level for #{name}."
    puts "Enter 'all' to see them all at once."
    puts "Enter a spell name to see that spell's info."
  end

  def print_spells(spells)
    # TODO Make this pretty
    puts spells.map(&:name)
  end

  def print_spells_at_level(spells, level)
    spells = spells.select { |spell| spell.level == level }
    puts "Level #{level} spells:"
    puts spells.map(&:name)
  end

  # nil.to_i == 0, so second line is needed
  def int_from_string(input)
    int = input.scan(/\-?\d+/)[0]
    int.to_i if int
  end

  def user_input
    gets.chomp
  end
end
