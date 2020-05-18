# This is responsile for scraping my webpage
# This file will use nokogiri.
# This file will never use puts

class Scraper
  URL = "https://5thsrd.org/"



 def classes
  doc = Nokogiri::HTML(HTTParty.get(URL))
   classes = doc.css("#spellcasting + table tbody td:last-child a")
                .each_with_object({}) do |link, classes|
                  href = link["href"]
                  klass = href.split('/')[2].sub("_spells","")
                  classes[klass] = href
                end
    puts classes.keys
 end
end
