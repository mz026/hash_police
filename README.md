[![Build Status](https://travis-ci.org/mz026/hash_police.svg?branch=master)](https://travis-ci.org/mz026/hash_police)
[![Code Climate](https://codeclimate.com/github/mz026/hash_police/badges/gpa.svg)](https://codeclimate.com/github/mz026/hash_police)

# HashPolice
A gem to check whether given to hashes are of the same format

## Installation

Add this line to your application's Gemfile:

    gem 'hash_police'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hash_police

## Usage

```ruby
rule = {
  :name => "a string",
  :age => 28,
  :favorites => [ "a string" ],
  :locations => [
    { :name => "string", :duration => 3 }
  ]
}

valid = {
  :name => "Jack",
  :age => 28,
  :favorites => [ "sport", "music" ],
  :locations => [
    { :name => "Taiwan", :duration => 25 },
    { :name => "US", :duration => 5 }
  ]
}

invalid = {
  :name => [],
  :age => "not a number",
  :locations => [
    { :name => "Taiwan", :duration => 25 },
    { :name => 23 }
  ]
}

police = HashPolice::Police.new(rule)

result = police.check(valid)
result.passed? # => true
result.error_messages # => ""

result = police.check(invalid)
result.passed? # => false
result.error_messages #=> "`name`: expect String, got Array; `favorites`: missing; `locations.1.name`: expect String, got Array; `locations.1.duration`: missing"
```

## RSpec matcher:

`HashPolice` provides a RSpec matcher `have_the_same_hash_format_as` checking the formats of two hashes.

```ruby
  require 'hash_police/rspec_matcher'

  it "should be able to use the matcher `have_the_same_hash_format_as`" do
    expected = { 'str' => '', 'an_arr' => [ 1 ] }
    to_be_checked = { 'str' => 'hola', :an_arr => [1,3,4] }

    expect(to_be_checked).to have_the_same_hash_format_as(expected)
  end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
