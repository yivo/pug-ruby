## Ruby wrapper for the Pug/Jade template engine

## About
This gem uses [pug-ruby](https://github.com/yivo/pug-ruby) to compile Pug/Jade templates. Please refer to that gem if you want to use Pug/Jade compiler directly.

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
npm install -g jade
```

## Installing Pug
Install Pug globally via npm:
```bash
npm install -g pug-cli
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
