# RubyMarkovify

A Ruby port of the excellent [markovify](https://github.com/jsvine/markovify) Python library.
## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ruby_markovify'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruby_markovify

## Usage

The ruby_markovify method names are identical to the ones in markovify, so if you need specific methods you can just read the markovify docs.

Here's a basic usage example:
```rb
require 'ruby_markovify'

# Read the corpus from a file
corpus = File.read('corpus.txt')

# Make a text from the corpus with state size 3
text = RubyMarkovify::Text.new(corpus, 3)

puts text.make_sentence  # Generates a random sentence
puts text.make_sentence_with_start('I have')  # Generates a random sentence starting with 'I have'
puts text.make_short_sentence(40)  # Generates a random sentence at most 40 characters long
```

In addition to the default markovify `Text` and `NewlineText` classes, ruby_markovify also includes an `ArrayText` class that uses an array (already split into sentences) as its corpus.

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/meew0/ruby_markovify.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

