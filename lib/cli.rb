# This class is responsible for communication with the user.
# This is where I will use "puts" alog
# This will neer use nokogiri
# This will have to invoce Scraper

class Cli
  def call
    welcome
    # TODO: choose by class, level, type?
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
    print_class_list
    handle_input_to_choose_class
  end

  def handle_input_to_choose_class
    loop_until_input(is_exit?, proc { choose_class_prompt }) do |input|
      if (klass = Klass.find_by_name_or_number(input))
        # sets input so exit can bubble up if needed
        prompt_for_choose_spells(klass)
      elsif eq_no_case?(input, "list")
        print_class_list
      else
        puts "Invalid Input. Try again?"
      end
    end
  end

  def choose_class_prompt
    puts "Enter a class number or name from the list"
    puts "to see which spells that class has available."
    puts "Enter 'list' to see the list again.\n\n"
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

  def prompt_for_choose_spells(klass)
    spells = klass.spells

    if spells.empty?
      print "Unfortunately, it doesn't look like #{klass.name}s"
      print " can learn any spells!\n\n"
    else
      handle_input_to_list_spells(klass.name, spells)
    end
  end

  def handle_input_to_list_spells(klass_name, spells)
    prompt = proc { class_spell_prompt(klass_name, spells.count) }

    loop_until_input(is_exit_or_back?, prompt) do |input|
      if Spell.valid_level?(lvl = i_from_s(input)) || eq_no_case?(input, "all")
        print_spells_by_level(spells, lvl)
      elsif (spell = spells.find { |s| eq_no_case?(s.name, input) })
        print_spell_info(spell)
      else
        puts "Invalid Input. Try again?"
      end
    end
  end

  # Checks input for breaking condition before and after loop
  # optionally calls prompt on each loop if not breaking
  # Nestable
  def loop_until_input(break_condition, prompt = nil)
    prompt&.call
    until break_condition.call((input = user_input))
      input = yield input
      break if break_condition.call(input)

      prompt&.call
    end
    input
  end

  def is_exit_or_back?
    proc { |input| eq_no_case?(input, "exit") || eq_no_case?(input, "back") }
  end

  def is_exit?
    proc { |input| eq_no_case?(input, "exit") }
  end

  def print_spell_info(spell)
    # TODO: get specifics of spell here
    SpellViewer.new(spell).print_spell
  end

  def class_spell_prompt(name, spell_count)
    puts "#{name}s have #{spell_count} spells."
    puts "Enter a level 0 - 9 to see spells of that level for #{name}."
    puts "Enter 'all' to see them all at once."
    puts "Enter a spell name to see that spell's info.\n\n"
  end

  def print_spells_by_level(spells, level = nil)
    SpellListViewer.new(spells).print_spells_by_level(level)
    puts
  end

  def i_from_s(input)
    int = input.scan(/\-?\d+/)[0]
    int.to_i if int.is_a?(String)
  end

  def user_input
    gets.chomp
  end
end
