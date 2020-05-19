# This class is responsible for communication with the user.
# This is where I will use "puts" alog
# This will neer use nokogiri
# This will have to invoce Scraper

class Cli
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

    handle_input_to_choose_class
  end

  def handle_input_to_choose_class
    until equals_ignore_case(input = user_input, "exit")
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

  def equals_ignore_case(str1, str2)
    str1.casecmp(str2).zero?
  end

  def prompt_for_klass_spell_choice(klass)
    spells = klass.spells

    if spells.empty?
      print "Unfortunately, it doesn't look like #{name}"
      print " can learn any spells!\n"
    else
      class_spell_prompt(klass.name, spells.count)
      handle_input_to_list_spells(klass.name, spells)
    end
  end

  def handle_input_to_list_spells(klass_name, spells)
    until equals_ignore_case(input = user_input, "exit")
      if (0..9).cover? int_from_string(input)
        print_spells_at_level(spells, int_from_string(input))
      elsif input.eql?("all")
        print_spells(spells)
      elsif (spell = spells.find { |s| equals_ignore_case(s.name, input) })
        print_spell_info(spell)
      else
        puts "Invalid Input. Try again?"
      end
      class_spell_prompt(klass_name, spells.count)
    end
  end

  def print_spell_info(spell)
    # TODO get specifics of spell here
    puts spell.name
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
