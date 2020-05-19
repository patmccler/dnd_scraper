# This is responsile for scraping my webpage
# This file will use nokogiri.
# This file will never use puts

class Scraper
  URL = "https://5thsrd.org/".freeze

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
    @classes = doc.css("#spellcasting + table tbody td:last-child a")
                  .each_with_object({}) do |link, classes|
                    href = link["href"]
                    klass = href.split("/")[2].sub("_spells", "").capitalize
                    classes[klass] = href
                  end
  end

  def self.scrape_class_spells(class_name)
    ["fireball"]
    # TODO Write me
  end
end
