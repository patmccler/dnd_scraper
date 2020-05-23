class SpellScraper
  URL = "https://5thsrd.org/".freeze

  def self.scrape_spell_info(spell)
    spell_doc = Nokogiri::HTML(HTTParty.get(URL + spell.link).body)
    tagline = spell_doc.css(".col-md-9 p:first-of-type")[0]
    cast_info = tagline.next_element

    update_type_info(spell, tagline.text)
    update_casting_info(spell, cast_info)
    update_description(spell, spell_doc)
  end

  def self.update_type_info(spell, tagline)
    spell.update_type_info(
      {
        ritual: tagline.include?("ritual"),
        school: find_spell_school(tagline),
      }
    )
  end

  def self.update_casting_info(spell, cast_info_p)
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

  def self.update_description(spell, doc)
    # Gets all the p elements after the casting description
    desc = doc.css(".col-md-9 p:nth-of-type(n+3)").map(&:text)
    desc = desc.join("\n\n")
    spell.description = desc
  end

  # Assumes the string is in one of the following formats:
  # <#>-Level <SCHOOL> (Ritual)
  # <#>-Level <SCHOOL>
  # <SCHOOL> Cantrip
  # Pattern finds the first word without numbers in it
  def self.find_spell_school(str)
    str = str.tr("^0-9a-zA-Z ", "")
    str.scan(/(?:\s|^)(\D\w+)(?=\b)/)[0][0].capitalize
  end

  def self.find_cast_time(cast_info_p)
    cast_info_p.child.next.text.strip
  end

  # Text elem after second 'strong' element
  def self.find_range(cast_info_p)
    cast_info_p.css("strong:nth-of-type(2)")[0].next.text.strip
  end

  # Text elem after third 'strong' element
  def self.find_components(cast_info_p)
    cast_info_p.css("strong:nth-of-type(3)")[0].next.text.strip
  end

  # Text elem after fourth 'strong' element
  def self.find_duration(cast_info_p)
    text = cast_info_p.css("strong:nth-of-type(4)")[0].next.text.strip
    text.gsub("Concentration, ", "")
  end

  def self.find_concentration(cast_info_p)
    text = cast_info_p.css("strong:nth-of-type(4)")[0].next.text.strip
    text.include?("Concentration")
  end
end
