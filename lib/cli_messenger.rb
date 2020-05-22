class CliMessenger
  class << self
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
      proc { CliMessenger.class_spell_prompt(name, spell_count) }
    end

    def farewell_message
      puts "Thanks for taking a look!"
    end

    def invalid_input_message
      puts "Invalid Input. Try again?"
    end

    def no_spells_for_class_message
      print "Unfortunately, it doesn't look like #{klass.name}s"
      print " can learn any spells!\n\n"
    end

    def print_class_list
      Klass.all.each_with_index do |klass, i|
        puts "#{i + 1}. #{klass.name}"
      end
      puts
    end

    def welcome_message
      puts "Hello, welcome to this DND Spell lookup app!"
      puts "Spells have both a level and a school,"
      puts "and can be learned by one or more classes.\n\n"
    end
  end
end
