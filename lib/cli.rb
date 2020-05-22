# This class is responsible for communication with the user.
# It uses @messenger class to actually print the messages.
# SpellViewer and Spell List viewer to handle printing those things.
class Cli
  def call
    @messenger = CliMessenger.new
    @messenger.welcome_message
    # TODO: choose by class, level, type?
    prompt_for_class_choice
    @messenger.farewell_message
  end

  def prompt_for_class_choice
    @messenger.print_class_list
    handle_input_to_choose_class
  end

  # At the top level of CLI, waiting for user input
  #
  def handle_input_to_choose_class
    loop_until_input_is(exit?, proc { choose_class_prompt }) do |input|
      if (klass = Klass.find_by_name_or_number(input))
        prompt_for_choose_spells(klass)
      elsif eq_no_case?(input, "list")
        @messenger.print_class_list
      else
        @messenger.invalid_input_message
      end
    end
  end

  def choose_class_prompt
    @messenger.choose_class_message
  end

  def eq_no_case?(str1, str2)
    str1.casecmp(str2).zero? if str1 && str2
  end

  def prompt_for_choose_spells(klass)
    spells = klass.spells

    if spells.empty?
      # don't go into next loop, if no spells exit
      @messenger.no_spells_for_class_message
    else
      handle_input_to_list_spells(klass.name, spells)
    end
  end

  # Level of the CLI where you can see the spells that a particular class knows
  # Alternately, you can enter a name of a spell to see that spell's info
  def handle_input_to_list_spells(klass_name, spells)
    prompt = @messenger.class_spell_prompt_proc(klass_name, spells.count)

    loop_until_input_is(exit_or_back?, prompt) do |input|
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
  def loop_until_input_is(break_condition, prompt = nil)
    prompt&.call
    until break_condition.call((input = gets.chomp))
      input = yield input
      break if break_condition.call(input)

      prompt&.call
    end
    input
  end

  def exit_or_back?
    proc { |input| eq_no_case?(input, "exit") || eq_no_case?(input, "back") }
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
