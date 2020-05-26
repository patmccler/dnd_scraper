# Object Oriented Ruby CLI Scraping Project checklist

CLI:
- [X] Provides an interface with the application (What is your domain?)
  - Domain - DND Spells and which characters know them
- [X] Pulls data from an external source (What are you grabbing on your first pass? What web page are you using?)
  - First pass - available classes. When @all is first called on Klass, the list is scraped from the website
- [X] Provides the user with a list and instructions to make a selection (What are you listing?)
  - List available methods to look at spells. Instructs which words will allow deeper dive
- [X] Protects against invalid user input (What happens when the user inputs a number instead of a letter or vice versa?)
  - Can type numbers or letters anywhere with appropriate response. On bad input, prompt is repeated
- [X] Pulls more data a 2nd time (What are you grabbing on your second pass? Are you going back to the same page or looking at a new one?)
  - Second pass - spells belonging to a class
    - Using link scraped during first time pass, same base page url but now a listing page
  - Third pass - specific info relating to spell
   - uses link scraped from second pass
- [X] Provides more data after the user makes a selection (What are you showing the user after your second pass?)
  - Showing the user how many spells the class has, and prompts them to choose a subset of those classes to see
    - From here, you can enter 0-9 or a spells name to see more
  - Third pass - shows the info relating to the specific spell
- [X] Provides a README.md with a short description, installation and execution instructions
- [X] Contains a Gemfile or gemspec that specifies the libraries needed for the application to launch
  - All set

Confirm:
- [X] Application uses Ruby Objects to communicate (and not global methods)
  - Klass, Spell, KlassSpell, and School objects
  - Klasses have many spells through KlassSpells
  - Spells have many Klasses through KlassSpells
  - Schools have many Spells
- [X] The application is generally DRY
  - Use findable and memoable module for reused logic in the classes
  - Build a custom loop for input because it was very similar logic repeating for each level of the cli
  - reused logic to handle input and display information whenever possible
    - Klass and School listings, and choosing, are handled by the same logic
    - printing a spell from anywhere handled by the same display logic
    - printing list of spells (and choosing from list) all handled by single method
- [X] Conforms to Nitro Ruby linting rules (Run `rubocop` on your project root directory and confirm it returns with 'no offenses detected'.)
  - no rubocop offenses
- [X] You have committed frequently
  - 135 commits as I write this
- [X] The message you write in each commit specifically relates to its code changes
  - Tried to commit anytime I changed a method, refactored something, added something new

Bonus:
- Talk with your instructor about any additional significant enhancements to your project