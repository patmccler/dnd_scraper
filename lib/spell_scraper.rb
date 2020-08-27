class SpellScraper
  URL = "https://5thsrd.org".freeze

  class << self
    def scrape_spell_info(spell)
      spell_doc = Nokogiri::HTML(HTTParty.get(URL + spell.link).body)
      tagline = spell_doc.css("h1 + p")[0]
      # binding.pry
      cast_info = tagline.next_element

      description = cast_info.next_element

      update_type_info(spell, tagline.text)
      update_casting_info(spell, cast_info)
      update_description(spell, description)
    end

  private

    def update_type_info(spell, tagline)
      spell.update_type_info(
        {
          ritual: tagline.include?("ritual"),
          school: find_spell_school(tagline),
        }
      )
    end

    def update_casting_info(spell, cast_info_p)
      spell.update_casting_info(
        {
          cast_time: find_cast_time(cast_info_p),
          range: find_range(cast_info_p),
          components: find_components(cast_info_p),
          duration: find_duration(cast_info_p),
          concentration: find_concentration(cast_info_p),
        }
      )
    end

    def update_description(spell, description)
      # Gets all the elements after the casting description
      desc = [description.text]
      while(description.next_element) do
        description = description.next_element
        desc << description.text

      end
      spell.description = desc.join("\n\n")
    end

    # Assumes the string is in one of the following formats:
    # <#>-Level <SCHOOL> (Ritual)
    # <#>-Level <SCHOOL>
    # <SCHOOL> Cantrip
    # Pattern finds the first word without numbers in it
    def find_spell_school(str)
      str = str.tr("^0-9a-zA-Z ", "")
      str.scan(/(?:\s|^)(\D\w+)(?=\b)/)[0][0].capitalize
    end

    def find_cast_time(cast_info_p)
      cast_info_p.child.next.text.strip
    end

    # Text elem after second 'strong' element
    def find_range(cast_info_p)
      cast_info_p.css("strong:nth-of-type(2)")[0].next.text.strip
    end

    # Text elem after third 'strong' element
    def find_components(cast_info_p)
      cast_info_p.css("strong:nth-of-type(3)")[0].next.text.strip
    end

    # Text elem after fourth 'strong' element
    def find_duration(cast_info_p)
      text = cast_info_p.css("strong:nth-of-type(4)")[0].next.text.strip
      text.gsub("Concentration, ", "")
    end

    def find_concentration(cast_info_p)
      text = cast_info_p.css("strong:nth-of-type(4)")[0].next.text.strip
      text.include?("Concentration")
    end
  end
end
