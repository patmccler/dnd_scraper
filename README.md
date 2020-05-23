## Pat's Project

# Description:
This app scrapes a wiki-like page (https://5thsrd.org/) relating to Dungeons and Dragons, fifth edition. In the game, each player controls a character. That character has a class. Through their class, some characters have access to spells. Each of these spells belongs to a particular school of magic.

Some spells belong to only one class, but some are known by more than one class. This means that a Paladin and a Cleric can learn some of the same spells.

This program aims to use classes as a starting point, collecting the spells that are available to each class. Then, the detailed information about those spells is captured as the spells are explored.

It would be possible to just scrape all the spells at the beginning, but then it wouldn't meet the criteria of scraping in response to the user making some input.
So instead of a database of spells, this is more akin to a collection of spells that grows as you investigate more.


# Instructions
Visit https://github.com/patmccler/dnd_scraper to see the repository.
Click the button to copy the ssh url, or otherwise clone the repository.
See [this link](https://help.github.com/en/github/creating-cloning-and-archiving-repositories/cloning-a-repository) for help cloning a repository.

Run `ruby bin/run.rb` in your terminal from the root of the project to start the application.

The program should start and prompt the user with a few choices. These choices determine which spells you can see and learn more about
- Class
    - You should start here
    - This presents the user with a (scraped) list of classes available in the game
  - Level: enter a number 0-9 or type all
    - from here, you can enter a level to see spells of that level known by the class
    - a table of spells will print
    - this is when the spells are created, and links to their further info is saved
  - Spell Name:
    - Enter the name of a spell known by the class
    - use the above tables if you aren't sure
    - this is when the spell's more detailed info is scraped
    - A card showing the spells info is displayed
  - List
    - print the list of Spell Schools again
- School
  - see a listing of Schools for spells you have already accessed
  - This will be empty to start! You have to learn about the spells elsewhere
  - Once populated, a list of schools will be displayed
    - choose a school to see a listing of those spells in the school, by level
  - List - print the list of Spell Schools again
- Level
  - See all the spells you have learned about, broken up by level
  - Enter a level - see a table of just those levels
  - Enter a spell - see the detailed break down
    (this will also scrape the spell info if it hasn't already been)
- Navigation
  - at any point you can type back to go up a level (until you get back to the top)
  - at any point, you can type exit to close the program
  - otherwise, a prompt should print after every input with instructions for what is available
