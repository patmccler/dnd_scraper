## Pat's Project

# Description:
This app scrapes a wiki page relating to Dungeon'ss and Dragon's, fifth edition. In the game, each player controls a character. That character has a class. Through their class, some characters have access to spells. Each of these spells belongs to a particular school of magic.

Some spells belong to only one class, but some are known by more than one class. This means that a Paladin and a Cleric can learn some of the same spells.


# Instructions
Visit https://github.com/patmccler/dnd_scraper to see the repository.
Click the button to copy the ssh url, or otherwise clone the repository

Run `ruby bin/run.rb` from the root of the project to start the application.

The program should start and prompt the user with a few choices. These choices determine which spells you can see and learn more about
- Class - You should start here
    - This presents the user with a (scraped) list of classes available in the game
  - Display spells: enter a number 0-9 or type all
    - from here, you can enter a level to see spells of that level known by the class
    - a table of spells will print
- Dig in to a spell: Enter the name of a spell known by the class
  - use the above tables if you aren't sure
  - this is when the spells more detailed info is scraped
- School - see a listing of Schools for spells you have already accessed
  - This will be empty to start! You have to learn about the spells elsewhere
  - Once populated, a list of schools will be displayed
    - choose a school to see a listing of those spells in the school, by level
- Level - See all the spells you have learned about, broken up by level
  - Enter a level - see a table of just those levels
  - Enter a spell - see the detailed break down
    (this will also scrape hte spell info if it hasn't already been)
