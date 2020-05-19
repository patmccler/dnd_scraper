# This class is responsible for communication with the user.
# This is where I will use "puts" alog
# This will neer use nokogiri
# This will have to invoce Scraper

class Cli
  def call
    welcome
    prompt_for_class_choice
    farewell
  end

  def classes
    Klass.all
  end

  def welcome
    puts "Hello, welcome to this DND Spell lookup app!"
    puts "Spells have both a level and a school,"
    puts "and can be learned by one or more classes.\n\n"
  end

  def farewell
    puts "Thanks for taking a look!"
  end

  def prompt_for_class_choice
    choose_class_prompt
    print_class_list
    handle_input_to_choose_class
  end

  def handle_input_to_choose_class
    until eq_no_case?(input = user_input, "exit") || eq_no_case?(input, "back")
      if (klass = Klass.find_by_name_or_number(input))
        # promt_for_klass_spell_choice returns last value, exit if needed
        input = prompt_for_klass_spell_choice(klass)
        break if eq_no_case?(input, "exit")
      elsif eq_no_case?(input, "list")
        print_class_list
      else
        puts "Invalid Input. Try again?"
      end
      choose_class_prompt
    end
    input
  end

  def choose_class_prompt
    puts "Enter a class number or name from the list"
    puts "to see which spells that class has available."
    puts "Enter 'list' to see the list again."
  end

  def print_class_list
    classes.each_with_index do |klass, i|
      puts "#{i + 1}. #{klass.name}"
    end
    puts
  end

  def eq_no_case?(str1, str2)
    str1.casecmp(str2).zero? if str1 && str2
  end

  def prompt_for_klass_spell_choice(klass)
    spells = klass.spells

    if spells.empty?
      print "Unfortunately, it doesn't look like #{klass.name}s"
      print " can learn any spells!\n\n"
    else
      class_spell_prompt(klass.name, spells.count)
      handle_input_to_list_spells(klass.name, spells)
    end
  end

  def handle_input_to_list_spells(klass_name, spells)
    until eq_no_case?(input = user_input, "exit") || eq_no_case?(input, "back")
      if Spell.valid_level?(int = i_from_s(input)) || eq_no_case?(input, "all")
        print_spells_by_level(spells, int)
      elsif (spell = spells.find { |s| eq_no_case?(s.name, input) })
        print_spell_info(spell)
      else
        puts "Invalid Input. Try again?"
      end
      class_spell_prompt(klass_name, spells.count)
    end
    input
  end

  def print_spell_info(spell)
    # TODO: get specifics of spell here
    puts spell.name
  end

  def class_spell_prompt(name, spell_count)
    puts "#{name}s have #{spell_count} spells."
    puts "Enter a level 0 - 9 to see spells of that level for #{name}."
    puts "Enter 'all' to see them all at once."
    puts "Enter a spell name to see that spell's info."
  end

  def print_spells_by_level(spells, level = nil)
    #TODO: make pretty - table?
    spells = spells.select { |spell| spell.level == level } if level
    puts "Level #{level} spells:" if level
    puts spells.map(&:name)
  end

  def i_from_s(input)
    int = input.scan(/\-?\d+/)[0]
    int.to_i if int.is_a?(String)
  end

  def user_input
    gets.chomp
  end
end
