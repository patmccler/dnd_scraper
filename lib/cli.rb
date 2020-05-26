# This class is responsible for communication with the user.
# It uses @messenger class to actually print the messages.
# SpellViewer and Spell List viewer to handle printing those things.
class Cli
  def call
    @messenger = CliMessenger.new
    @messenger.welcome_message
    handle_input_while_choose_lookup_type
    @messenger.farewell_message
  end

  def handle_input_while_choose_lookup_type
    @messenger.lookup_type_message
    prompt = @messenger.lookup_by_loop_prompt

    loop_until_input_is(exit?, nil, prompt: prompt) do |input|
      if eql_no_case?(input, "class") then prompt_for_choose_class
      elsif eql_no_case?(input, "level") then prompt_for_choose_level
      elsif eql_no_case?(input, "school") then prompt_for_choose_school
      else
        @messenger.invalid_input_message
      end
    end
  end

  def prompt_for_choose_level
    @messenger.choose_level_message
    handle_input_while_list_spells(Spell.all)
  end

  def prompt_for_choose_school
    if School.all.empty?
      # don't go into next loop, if no schools exit
      @messenger.no_schools_message
    else
      @messenger.choose_school_message
      handle_input_while_list_schools
    end
  end

  # Gets input and see if user has picked a school of spells
  def handle_input_while_list_schools
    prompt = @messenger.choose_school_prompt

    loop_until_input_is(exit?, back?, prompt: prompt) do |input|
      if (school = School.find_by_name_or_number(input))
        handle_input_while_list_spells(school.spells, name: school.name)
      elsif eql_no_case?(input, "list")
        @messenger.print_memoable_list(School)
      else
        @messenger.invalid_input_message
      end
    end
  end

  # Gets input and see if user has picked a calss
  def prompt_for_choose_class
    @messenger.print_memoable_list(Klass)
    prompt = @messenger.choose_class_prompt

    loop_until_input_is(exit?, back?, prompt: prompt ) do |input|
      if (klass = Klass.find_by_name_or_number(input))
        prompt_on_class_chosen(klass)
      elsif eql_no_case?(input, "list")
        @messenger.print_memoable_list(Klass)
      else
        @messenger.invalid_input_message
      end
    end
  end

  def eql_no_case?(str1, str2)
    str1.casecmp(str2).zero? if str1 && str2
  end

  def prompt_on_class_chosen(klass)
    if klass.spell_less?
      # don't go into next loop, if no spells exist
      @messenger.no_spells_for_class_message(klass.name)
    else
      handle_input_while_list_spells(klass.spells, name: klass.name)
    end
  end

  # Level of the CLI where you can see the spells that a particular class knows
  # Alternately, you can enter a name of a spell to see that spell's info
  def handle_input_while_list_spells(spells, name: nil)
    prompt = @messenger.spell_list_prompt(spells.count, name: name)

    loop_until_input_is(exit?, back?, prompt: prompt) do |input|
      if (lvl = Spell.level_from_str(input)) || eql_no_case?(input, "all")
        print_spells_by_level(spells, lvl)
      elsif (spell = Spell.find_by_name_from_list(spells, input))
        print_spell_info(spell)
      else
        @messenger.invalid_input_message
      end
    end
  end

  # Checks input for exit condition before and after loop
  # optionally checks for a back condition instead of a total exit
  # optionally calls prompt on each loop, if not breaking
  # Nestable - if you want to bubble a response up, return it
  def loop_until_input_is(exit_condition, back_condition = nil, prompt: nil)
    prompt&.call
    until exit_condition.call(input = gets.chomp) || back_condition&.call(input)
      input = yield input
      break if exit_condition.call(input)

      prompt&.call
    end
    # Break this loop, but dont bubble it up to outer loop
    input = "" if back_condition&.call(input)
    input
  end

  def back?
    proc { |input| eql_no_case?(input, "back") }
  end

  def exit?
    proc { |input| eql_no_case?(input, "exit") }
  end

  def print_spell_info(spell)
    SpellViewer.new(spell).print_spell
  end

  def print_spells_by_level(spells, level = nil)
    spells = spells.select { |s| s.level == level} if level
    SpellListViewer.new(spells).print_spells(level)
  end
end
