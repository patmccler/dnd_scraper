# Object Oriented Ruby CLI Scraping Project checklist

CLI:
- [ ] Provides an interface with the application (What is your domain?)
- [ ] Pulls data from an external source (What are you grabbing on your first pass? What web page are you using?)
- [ ] Provides the user with a list and instructions to make a selection (What are you listing?)
- [ ] Protects against invalid user input (What happens when the user inputs a number instead of a letter or vice versa?)
- [ ] Pulls more data a 2nd time (What are you grabbing on your second pass? Are you going back to the same page or looking at a new one?)
- [ ] Provides more data after the user makes a selection (What are you showing the user after your second pass?)
- [ ] Provides a README.md with a short description, installation and execution instructions
- [ ] Contains a Gemfile or gemspec that specifies the libraries needed for the application to launch

Confirm:
- [ ] Application uses Ruby Objects to communicate (and not global methods)
- [ ] The application is generally DRY
- [ ] Conforms to Nitro Ruby linting rules (Run `rubocop` on your project root directory and confirm it returns with 'no offenses detected'.)
- [ ] You have committed frequently
- [ ] The message you write in each commit specifically relates to its code changes

Bonus:
- Talk with your instructor about any additional significant enhancements to your project