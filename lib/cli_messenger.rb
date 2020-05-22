class CliMessenger
  def choose_class_message
    puts "Enter a class number or name from the list"
    puts "to see which spells that class has available."
    puts "Enter 'list' to see the list again.\n\n"
  end

  def class_spell_prompt(name, spell_count)
    puts "#{name}s have #{spell_count} spells."
    puts "Enter a level 0 - 9 to see spells of that level for #{name}."
    puts "Enter 'all' to see them all at once."
    puts "Enter a spell name to see that spell's info.\n\n"
  end

  def class_spell_prompt_proc(name, spell_count)
    proc { class_spell_prompt(name, spell_count) }
  end

  def lookup_by_loop_prompt
    proc { puts "Type 'class', 'school', or 'level'" }
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

  def no_spells_for_class_message(name)
    print "Unfortunately, it doesn't look like #{name}s"
    print " can learn any spells!\n\n"
  end

  def print_class_list
    Klass.all.each_with_index do |klass, i|
      puts "#{i + 1}. #{klass.name}"
    end
    puts
  end

  def welcome_message
    puts "Hello, and welcome to this DND Spell Information app!"
    puts "Spells have both a level and a school,"
    puts "and can be learned by one or more classes.\n\n"
    puts "Follow the prompts, type 'back to return to the previous screen"
    puts "Or type 'exit' to quit at any time."
  end
end
