# This is responsile for scraping my webpage
# This file will use nokogiri.
# This file will never use puts

class Scraper
  URL = "https://5thsrd.org/".freeze

  # This shouldnt change across a given run of the program, so save it
  def self.doc
    @doc ||= Nokogiri::HTML(HTTParty.get(URL).body)
  end

  # sets the @classes variable
  def self.scrape_classes
    doc = Nokogiri::HTML(HTTParty.get(URL).body)

    # gets the second column of the table under character
    # these are the names of the available classes
    doc.css("#character + table tbody td:nth-child(2) a").map(&:text)
  end

  # moved from scrape class above may need this later
  def self.class_spell_links
    # gets the last column of the table at the bottom
    # these are the links to the class spell lists
    doc.css("#spellcasting + table tbody td:last-child a")
       .each_with_object({}) do |link, classes|
         href = link["href"]
         klass = href.split("/")[2].sub("_spells", "").capitalize
         classes[klass] = href
       end
  end

  def self.scrape_class_spells(klass)
    klass_spell_path = scrape_class_spell_link(klass.name)
    scrape_spells_from_link_by_level(URL + klass_spell_path)
  end

  def self.scrape_class_spell_link(class_name)
    doc.css("#spellcasting + table a[href*=#{class_name.downcase}]").attr("href")&.value || ""
  end

  def self.scrape_spells_from_link_by_level(url)
    return [] if url == URL

    spell_doc = Nokogiri::HTML(HTTParty.get(url).body)

    spell_doc.css("h2").map do |section|
      section.next_element.css("a").map do |anchor|
        name = anchor.text
        link = anchor["href"].gsub("../../../", "")
        Spell.find_or_create(name, section.text, link)
      end
    end.flatten
    # section map, an array of arrays of spells
  end
end
