## Ruby wrapper for the Jade and Pug

[![Gem Version](https://badge.fury.io/rb/pug-ruby.svg)](https://badge.fury.io/rb/pug-ruby)
[![Build Status](https://travis-ci.org/yivo/pug-ruby.svg?branch=master)](https://travis-ci.org/yivo/pug-ruby)

<img width="49.138705862%" alt="jade" align="left" src="https://user-images.githubusercontent.com/7421323/29007509-4fb4e004-7b0d-11e7-9b21-6bdd98a24344.png">

<img width="47.482344991%" alt="pug" src="https://user-images.githubusercontent.com/7421323/29007510-4fcdb638-7b0d-11e7-80c7-e3c49434ca8a.png">

## About

This gem is a wrapper for Jade / Pug template engines.
 
You can compile both Jade templates ([version 1.x](https://github.com/pugjs/pug/tree/v1.x.x)) and Pug ([version 2.x](https://github.com/pugjs/pug)).

```ruby
Jade.compile(source, options)
Pug.compile(source, options)
```

## Installing gem

**RubyGems users**

1. Run `gem install pug-ruby --version "~> 2.0"`. 
2. Add `require "pug-ruby"` to your code.

**Bundler users**

1. Add to your Gemfile:
```ruby
gem "pug-ruby", "~> 1.0"
```
2. Run `bundle install`.

## Installing Jade

Install Jade globally via npm:
```bash
npm install --global jade
```
You may require `sudo` depending on your system.

## Installing Pug

Install Pug globally via npm:
```bash
npm install --global pug
```
You may require `sudo` depending on your system.

## Switching Jade / Pug version

The gem is shipped with different prebuilt versions of Jade and Pug.
That prebuilt versions are Web version, e.g. they are limited to browser JavaScript.
Advanced Jade / Pug features like `includes`, `extends`, `block`, and other require filesystem access.
You will not be able to use that features while dealing with shipped Jade / Pug.
Use system Jade / Pug in such cases.

**Switching the version permanently:**
```ruby
Pug.use "2.0.0"      # You have just switched to shipped Pug 2.0.0.
Pug.compiler.version # Returns "2.0.0".

Pug.use :system      # You have just switched to system Pug.
Pug.compiler.version # Returns the version of your system-wide installed Pug.
```

**Switching the version temporarily:**
```ruby
Jade.use "1.11.0" # You have just switched to shipped Jade 1.11.0.

Jade.use "1.9.2" do
  # You have just switched to shipped Jade 1.9.2.
  Jade.compiler.version # Returns "1.9.2".

  # Do you stuff.
end

# You have just switched back to the 1.11.0.
Jade.compiler.version # Returns "1.11.0".
```

**Switching to the system Jade / Pug:**

```ruby
# Pass :system to switch to the system Pug.
Pug.use :system
```

**Shipped versions of Jade:**

* 1.0.0
* 1.0.1
* 1.0.2
* 1.1.0
* 1.1.1
* 1.1.2
* 1.1.3
* 1.1.4
* 1.1.5
* 1.2.0
* 1.3.0
* 1.3.1
* 1.4.0
* 1.4.1
* 1.4.2
* 1.5.0
* 1.6.0
* 1.7.0
* 1.8.0
* 1.8.1
* 1.8.2
* 1.9.0
* 1.9.1
* 1.9.2
* 1.10.0
* 1.11.0

**Shipped versions of Jade runtime:**

* 1.0.0
* 1.0.1
* 1.0.2
* 1.1.0
* 1.1.1
* 1.1.2
* 1.1.3
* 1.1.4
* 1.1.5
* 1.2.0
* 1.3.0
* 1.3.1
* 1.4.0
* 1.4.1
* 1.4.2
* 1.5.0
* 1.6.0
* 1.7.0
* 1.8.0
* 1.8.1
* 1.8.2
* 1.9.0
* 1.9.1
* 1.9.2
* 1.10.0
* 1.11.0

**Shipped versions of Pug:**

* 2.0.0-beta1
* 2.0.0-beta2
* 2.0.0-beta3
* 2.0.0-beta4
* 2.0.0-beta5
* 2.0.0-beta6
* 2.0.0-beta7
* 2.0.0-beta8
* 2.0.0-beta9
* 2.0.0-beta10
* 2.0.0-beta11
* 2.0.0-beta.12 (this is not an error)
* 2.0.0-rc.1
* 2.0.0-rc.2
* 2.0.0-rc.3

**Shipped versions of Pug runtime:**

* 2.0.0
* 2.0.1
* 2.0.2

## Configuring Jade and Pug

Access Pug and Jade configurations:
```ruby
Jade.config.pretty = true
Pug.config.pretty  = true
```

Refer to official website for configuration options: 

[jade-lang.com (Sorry, Web Archive only)](http://web.archive.org/web/*/jade-lang.com)

[pugjs.org](https://pugjs.org)

## Running tests

1. Install both Jade and Pug: `npm install --global jade pug-cli`.
2. Install gem dependencies: `bundle install`.
3. Finally, run tests: `bundle exec rake test`.
