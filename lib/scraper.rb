# Responsible for scraping klass names and links to further info
class Scraper
  URL = "https://5thsrd.org/".freeze

  class << self
    # This shouldnt change across a given run of the program, so save it
    def doc
      @doc ||= Nokogiri::HTML(HTTParty.get(URL).body)
    end

    # gets the second column of the table under character
    # these are the names of the available classes
    def scrape_classes
      doc.css("#character + table tbody td:nth-child(2) a").map(&:text)
    end

    # returns all the spells the given class knows
    def scrape_class_spells(klass)
      klass_spell_path = scrape_class_spell_link(klass.name)
      scrape_spells_from_link_by_level(URL + klass_spell_path)
    end

  private

    # gets the link to a list of spells for a particular class
    def scrape_class_spell_link(klass_name)
      klass_link_css = "#spellcasting + table a[href*=#{klass_name.downcase}]"
      doc.css(klass_link_css).attr("href")&.value || ""
    end

    # returns an array of spells from a page that has spells sorted by level
    def scrape_spells_from_link_by_level(url)
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
end
