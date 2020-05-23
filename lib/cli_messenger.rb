class CliMessenger
  def choose_class_prompt
    proc do
      puts "Enter a class number or name from the list"
      puts "to see which spells that class has available."
      puts "Enter 'list' to see the list again, or 'back' to go back\n\n"
    end
  end

  # put once before loop starts
  def choose_level_message
    puts "Every spell has a level.\nSome spells can be cast at a higher level"\
    " than base for more powerful effect, if the character is capable"\
    " of casting spells at that level.\n\n"
  end

  # put every time that loop is execupted
  def choose_level_loop_prompt
    proc do
      puts "Enter a number '0' (or 'cantrip') - '9'"
      puts "\tTo see the spells of that level you know about"
      puts "Enter 'all' to see all spells, or 'back' to return\n\n"
    end
  end

  def choose_school_message
    puts "Each spell has a school."
    puts "Choose from the list to see spells that belong to it."
    puts
    print_memoable_list(School)
  end

  def choose_school_prompt
    proc do
      puts "Pick a school from list, or type 'list' to see the list again"
      puts "type 'back' to go back or 'exit' to quit."
    end
  end

  def spell_list_prompt(spell_count, name: nil)
    proc do
      puts "There are #{spell_count} #{name ? name + ' ' : ''}spells."
      puts "Enter a level 0 - 9 to see spells of that level."
      puts "Enter 'all' to see them all at once."
      puts "Enter a spell name to see that spell's info."
      puts "Enter 'back' to go back.\n\n"
    end
  end

  def lookup_by_loop_prompt
    proc do
      puts "How do you want to look up spells?"
      puts "\t'class', 'school', or 'level'\n\n"
    end
  end

  def farewell_message
    puts "Thanks for taking a look!"
  end

  def invalid_input_message
    puts "Invalid Input. Try again?\n\n"
  end

  def lookup_type_message
    puts "Enter 'class' to look up spells by class"
    puts "\tThis is how you learn about new spells"
    puts "Enter 'school' to see spells you've learned about, by school"
    puts "Enter 'level' to see the spells you've learned about, by level"
  end

  def no_schools_message
    puts "No spells know their school yet - Look into specific spells to learn"\
    " their schools."
  end

  def no_spells_for_class_message(name)
    print "Unfortunately, it doesn't look like #{name}s"
    print " can learn any spells!\n\n"
  end

  def print_memoable_list(klass)
    klass.all.each_with_index do |klass_instance, i|
      puts "#{i + 1}. #{klass_instance.name}"
    end
    puts
  end

  def welcome_message
    puts "Hello, and welcome to this DND Spell Information app!"
    puts "Spells have both a level and a school,"
    puts "and can be learned by one or more classes.\n\n"
    puts "Follow the prompts, type 'back to return to the previous screen"
    puts "Or type 'exit' to quit at any time.\n\n"
  end
end
