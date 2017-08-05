## Ruby wrapper for the Pug/Jade template engine

[![Gem Version](https://badge.fury.io/rb/pug-ruby.svg)](https://badge.fury.io/rb/pug-ruby)
[![Build Status](https://travis-ci.org/yivo/pug-ruby.svg?branch=1.x)](https://travis-ci.org/yivo/pug-ruby)

## About
This gem is wrapper for Pug/Jade command line interface. You can compile both Jade templates ([version 1.x](https://github.com/pugjs/pug/tree/v1.x.x)) and Pug ([version 2.x](https://github.com/pugjs/pug)).
<br>
```ruby
Jade.compile(source, options)
Pug.compile(source, options)
```

## Installing gem
Run `gem install pug-ruby -v '~> 1.0'`. Add `require 'pug-ruby'` to your code.


**If you are using bundler.**
<br>
Add to your Gemfile:
```ruby
gem 'pug-ruby', '~> 1.0'
```

## Installing Jade
Install Jade globally via npm:
```bash
npm install --global jade
```

## Installing Pug
Install Pug globally via npm:
```bash
npm install --global pug-cli
```

## Configuring Pug and Jade
Access Pug and Jade configurations:
```ruby
Jade.config.compile_debug = false
Pug.config.compile_debug  = false
```

Refer to official website for configuration options meaning: 
<br>
[pugjs.org](https://pugjs.org)
<br>
[jade-lang.com (sorry, webarchive only)](http://web.archive.org/web/*/jade-lang.com)

## Running Tests
1. Install both Pug and Jade 
2. Install gem dependencies: `bundle install`
3. Finally run tests: `bundle exec rake test`
