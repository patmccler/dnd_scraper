# This is responsile for scraping my webpage
# This file will use nokogiri.
# This file will never use puts

class Scraper
  URL = "https://5thsrd.org/"


  # exposes the names of the classes available
  def classes
    @classes ||= scrape_classes
  end

  # sets the @classes variable
  def scrape_classes
    doc = Nokogiri::HTML(HTTParty.get(URL))

    # gets the second column of the table under character
    # these are the names of the available classes
    @classes = doc.css("#character + table tbody td:nth-child(2) a")
                  .map { |link| link.text }
  end

  #moved from scrape class above may need this later
  def get_class_spell_links
    # gets the last column of the table at the bottom
    # these are the links to the class spell lists
    @classes = doc.css("#spellcasting + table tbody td:last-child a")
                .each_with_object({}) do |link, classes|
                  href = link["href"]
                  klass = href.split('/')[2].sub("_spells","").capitalize
                  classes[klass] = href
                end
  end
end
