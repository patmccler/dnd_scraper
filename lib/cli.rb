# This class is responsible for communication with the user.
# It uses @messenger class to actually print the messages.
# SpellViewer and Spell List viewer to handle printing those things.
class Cli
  def call
    @messenger = CliMessenger.new
    @messenger.welcome_message
    # prompt_for_choose_class
    prompt_for_lookup_type
    @messenger.farewell_message
  end

  def prompt_for_lookup_type
    @messenger.lookup_type_message
    handle_input_to_choose_lookup_type
  end

  def handle_input_to_choose_lookup_type
    prompt = @messenger.lookup_by_loop_prompt
    loop_until_input_is(exit?, nil, prompt) do |input|
      input = input.downcase
      if input == "class" then prompt_for_choose_class
      elsif input == "level" then prompt_for_choose_level
      elsif input == "school" then prompt_for_choose_school
      else
        @messenger.invalid_input_message
      end
    end
  end

  def prompt_for_choose_level
    @messenger.choose_level_message

    prompt = @messenger.choose_level_loop_prompt
    loop_until_input_is(exit?, back?, prompt) do |input|
      input = input.downcase
      if Spell.valid_level?(i_from_s(input))
        puts "PRINTING LEVEL #{i_from_s(input)} SPELLS"
        # TODO: display these
      else
        @messenger.invalid_input_message
      end
    end
  end

  def prompt_for_choose_class
    @messenger.print_class_list
    handle_input_to_choose_class
  end

  # At the top level of CLI, waiting for user input
  #
  def handle_input_to_choose_class
    prompt = @messenger.choose_class_prompt
    loop_until_input_is(exit?, back?, prompt) do |input|
      if (klass = Klass.find_by_name_or_number(input))
        prompt_for_choose_spells(klass)
      elsif eq_no_case?(input, "list")
        @messenger.print_class_list
      else
        @messenger.invalid_input_message
      end
    end
  end

  def eq_no_case?(str1, str2)
    str1.casecmp(str2).zero? if str1 && str2
  end

  def prompt_for_choose_spells(klass)
    spells = klass.spells

    if spells.empty?
      # don't go into next loop, if no spells exit
      @messenger.no_spells_for_class_message(klass.name)
    else
      handle_input_to_list_spells(klass.name, spells)
    end
  end

  # Level of the CLI where you can see the spells that a particular class knows
  # Alternately, you can enter a name of a spell to see that spell's info
  def handle_input_to_list_spells(klass_name, spells)
    prompt = @messenger.class_spell_prompt(klass_name, spells.count)

    loop_until_input_is(exit?, back?, prompt) do |input|
      if Spell.valid_level?(lvl = i_from_s(input)) || eq_no_case?(input, "all")
        print_spells_by_level(spells, lvl)
      elsif (spell = spells.find { |s| eq_no_case?(s.name, input) })
        print_spell_info(spell)
      else
        @messenger.invalid_input_message
      end
    end
  end

  # Checks input for breaking condition before and after loop
  # optionally calls prompt on each loop if not breaking
  # Nestable - if you want to bubble a response up, return it
  def loop_until_input_is(exit_condition, back_condition = nil, prompt = nil)
    prompt&.call
    until exit_condition.call(input = gets.chomp) || back_condition&.call(input)
      input = yield input
      break if exit_condition.call(input)

      prompt&.call
    end
    input = "" if back_condition&.call(input)
    input
  end

  def back?
    proc { |input| eq_no_case?(input, "back")}
  end

  def exit?
    proc { |input| eq_no_case?(input, "exit") }
  end

  def print_spell_info(spell)
    SpellViewer.new(spell).print_spell
  end

  def print_spells_by_level(spells, level = nil)
    SpellListViewer.new(spells).print_spells_by_level(level)
  end

  def i_from_s(input)
    int = input.scan(/\-?\d+/)[0]
    int.to_i if int.is_a?(String)
  end
end
