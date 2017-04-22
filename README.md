# Mtg-Card-Finder

Welcome to MTG Card Finder! Find the highest rising/falling card prices on the Magic the Gathering open market.
Updated daily, and able to save your search into a local .csv file for your own personal logging/card hunting.

Currently logs Standard and Modern formats only.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mtg-card-finder'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mtg-card-finder

## Usage
Type the below on your terminal to begin the app:

$ mtg-card-finder

When the application begins, choose between four different pricing options:

[1] Standard: rising cards today                                                                                          
[2] Modern: rising cards today                                                                                             
[3] Standard: crashing cards today                                                                                          
[4] Modern: crashing cards today

After you have made your choice the app will load a list of the top 40-50 for the day.

Each card will display its 'name', what card 'set' it's from, the current 'market value',
and the amount that it has 'raised' or 'fallen' for the day.

You will then be asked for four more additional options:

[1] search for a different format's market?                                                        
[2] save the current card search listing into a CSV file?                                        
[3] purchase one of the queried cards in the open market?                                             
[4] exit the program?

Option 1 will let you search for another of the initially provided formats at the start of the application.
Option 2 will locally save the queried listing into a .csv file.
Option 3 will provide you with a url link that directs you to eBay's lowest priced bids for the chosen card.
Option 4 exits the application.

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/JuanGongora/mtg-card-finder. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Bugs

Current bugs: https://github.com/JuanGongora/mtg-card-finder/issues

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
