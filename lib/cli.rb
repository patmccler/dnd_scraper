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
    handle_input_for_choose_level
  end

  def handle_input_for_choose_level
    prompt = @messenger.choose_level_loop_prompt
    loop_until_input_is(exit?, back?, prompt) do |input|
      if Spell.valid_level?(i_from_s(input)) || match_all?(input)
        print_spells_by_level(Spell.all, i_from_s(input))
      elsif (spell = Spell.find_by_name_from_list(Spell.all, input))
        print_spell_info(spell)
      else
        @messenger.invalid_input_message
      end
    end
  end

  def prompt_for_choose_school
    schools = Spell.schools

    if schools.empty?
      # don't go into next loop, if no schools exit
      @messenger.no_schools_for_spells_message
    else
      @messenger.choose_school_message
      handle_input_to_list_spells(schools)
    end
  end

  # Gets input and see if user has picked a spell class
  def handle_input_to_list_schools(schools)
    prompt = @messenger.choose_school_prompt
    loop_until_input_is(exit?, back?, prompt) do |input|
      # TODO: School choices here
    end
  end

  # Gets input and see if user has picked a calss
  def prompt_for_choose_class
    @messenger.print_class_list
    loop_until_input_is(exit?, back?, @messenger.choose_class_prompt) do |input|
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
      if Spell.valid_level?(lvl = i_from_s(input)) || match_all?(input)
        print_spells_by_level(spells, lvl)
      elsif (spell = Spell.find_by_name_from_list(spells, input))
        print_spell_info(spell)
      else
        @messenger.invalid_input_message
      end
    end
  end

  def match_all?(str)
    eq_no_case?(str, "all")
  end

  def find_spell(spells, name)
    spells.find { |s| eq_no_case?(s.name, name) }
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
    proc { |input| eq_no_case?(input, "back") }
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

  # returns nil if no number, not 0 like .to_i
  def i_from_s(input)
    int = input.scan(/\-?\d+/)[0]
    int.to_i if int.is_a?(String)
  end
end
