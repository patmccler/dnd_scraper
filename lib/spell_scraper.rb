class SpellScraper
  URL = "https://5thsrd.org/".freeze

  def self.scrape_spell_info(spell)
    spell_doc = Nokogiri::HTML(HTTParty.get(URL + spell.link).body)
    tagline = spell_doc.css(".col-md-9 p:first-of-type")[0]
    cast_info = tagline.next_element

    spell.ritual = tagline.text.include?("ritual")
    spell.type = find_spell_type(tagline.text)
    spell.cast_time = find_cast_time(cast_info)
    spell.range = find_range(cast_info)

    binding.pry
  end

  # Assumes the string is in one of the following formats:
  # <#>-Level <TYPE> (Ritual)
  # <#>-Level <TYPE>
  # <TYPE> Cantrip
  # Pattern finds the first word without numbers in it
  def self.find_spell_type(str)
    str.scan(/(?:^|\s)(\w+)(?=$|\s)/)[0][0].capitalize
  end

  def self.find_cast_time(cast_info_p)
    cast_info_p.child.next.text.strip
  end

  # Text elem after second 'strong' element
  def self.find_range(cast_info_p)
    cast_info_p.css("strong:nth-of-type(2)")[0].next.text.strip
  end

end