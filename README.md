## 🐶 Compile Jade and Pug from Ruby

[![Gem Version](https://badge.fury.io/rb/pug-ruby.svg)](https://badge.fury.io/rb/pug-ruby)
[![Build Status](https://travis-ci.org/yivo/pug-ruby.svg?branch=master)](https://travis-ci.org/yivo/pug-ruby)

<img width="49.710808069%" alt="jade" align="left" src="https://user-images.githubusercontent.com/7421323/29007509-4fb4e004-7b0d-11e7-9b21-6bdd98a24344.png">

<img width="48.035162854%" alt="pug" src="https://user-images.githubusercontent.com/7421323/29007510-4fcdb638-7b0d-11e7-80c7-e3c49434ca8a.png">

## About

`pug-ruby` is a gem that allows you to easily compile Jade and Pug templates from Ruby.

**You can compile both Jade and Pug:**

* supports Jade [1.x.x](https://github.com/pugjs/pug/tree/v1.x.x).
* supports Pug [2.x.x](https://github.com/pugjs/pug/tree/master).
 
**You can choose what compiler to use:**

* *system compiler* – compiler that is installed globally via NPM.
* *shipped compiler* – compiler that is shipped with the gem as Web version.
 
Available versions of shipped compilers are listed below.
 
**You can lock the Jade / Pug version:**

```ruby
NEEDED_JADE_VERSION = "1.9.2"

unless Jade.compiler.version == NEEDED_JADE_VERSION
  raise "Jade #{NEEDED_JADE_VERSION} needed. You have #{Jade.compiler.version}."
end
```

**You can configure globally or per compilation:**

```ruby
Jade.config.pretty = true
Jade.compile "div Hello, Jade!", pretty: false
```

**You can render template or compile it to the JavaScript function:**

```ruby
Jade.compile "div=greeting", locals: { greeting: "Hello, Jade!" } # => "<div>Hello, Jade!</div>"
Jade.compile "div=greeting", client: true                         # => "(function(jade) { function template(locals) {var buf = [];var jade_mixins = {};var jade_interp;;var locals_for_with = (locals || {});(function (greeting) {buf.push("<div>" + (jade.escape(null == (jade_interp = greeting) ? "" : jade_interp)) + "</div>");}.call(this,"greeting" in locals_for_with?locals_for_with.greeting:typeof greeting!=="undefined"?greeting:undefined));;return buf.join("");}; return template; }).call(this, jade);"
```
 
**Advanced language features like `include`, `extends` and `block` are supported (only system compilers):**
```jade
//- File: /var/www/app/views/header.jade
ul
  li: a(href='/') Home
```

```jade
//- File: /var/www/app/views/layout.jade
doctype html
html
  head
      title Application
  body
    header
      include ./header.jade
```

```ruby
Jade.use :system

Jade.compile File.read("/var/www/app/views/layout.jade"), filename: "/var/www/app/views/layout.jade"
  # => "<!DOCTYPE html><html><head><title>Application</title></head><body><header><ul><li><a href="/">Home</a></li></ul></header></body></html>"
```

## Installing gem

**RubyGems users**

1. Run `gem install pug-ruby --version "~> 2.0.0"`. 
2. Add `require "pug-ruby"` to your code.

**Bundler users**

1. Add to your Gemfile:
```ruby
gem "pug-ruby", "~> 2.0.0"
```
2. Run `bundle install`.

## Installing Jade

Only install if you want to use **system** compiler.

Install Jade globally via npm:
```bash
npm install --global jade
```
You may require `sudo` depending on your system.

## Installing Pug

Only install if you want to use **system** compiler.

Install Pug globally via npm:
```bash
npm install --global pug
```
You may require `sudo` depending on your system.

## Switching Jade / Pug version

The gem is shipped with different prebuilt versions of Jade and Pug.
That prebuilt versions are Web version, e.g. they are limited to browser JavaScript.
Advanced Jade / Pug features like `includes`, `extends`, `block`, and others require filesystem access.
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

# You have been switched back to the 1.11.0.
Jade.compiler.version # Returns "1.11.0".
```

**Switching to the system Jade / Pug:**

```ruby
# Pass :system to switch to the system Jade / Pug.
Jade.use :system
Pug.use  :system
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
* 2.0.0-beta12
* 2.0.0-rc.1
* 2.0.0-rc.2
* 2.0.0-rc.3
* 2.0.0-rc.4

**Shipped versions of Pug runtime:**

* 2.0.0
* 2.0.1
* 2.0.2

## Configuring Jade / Pug

**Accessing configuration:**

```ruby
Jade.config
```

**Getting configuration options:**

```ruby
Jade.config.pretty  # => false
Jade.config.pretty? # => false
```

**Setting configuration options:**

```ruby
Jade.config.pretty = true
```

**Setting custom configuration options:**

```ruby
Jade.config.custom_option = "value"
```

**Serializing configuration:**

```ruby
Jade.config.to_h
  # => { filename: nil, doctype: nil, pretty: false, self: false, compile_debug: false, globals: [], name: "template" }
```

**The documentation for configuration options can be found here:**

* [Official Jade website (Web Archive only)](http://web.archive.org/web/*/jade-lang.com/api)
* [Jade CLI utility reference](https://github.com/pugjs/pug/blob/v1.x.x/bin/jade.js)
* [Official Pug website](https://pugjs.org/api/reference.html)
* [Pug CLI utility reference](https://github.com/pugjs/pug-cli/blob/master/index.js)

**Pass an options to `Jade#compile` or `Pug#compile` as second argument to override global config:**

```ruby
Jade.compile "h1 Title\ndiv Content"
  # => "<h1>Title</h1><div>Content</div>"
  
Jade.compile "h1 Title\ndiv Content", pretty: true
  # => "<h1>Title</h1>\n<div>Content</div>"  
```

## Running tests

1. Install both Jade and Pug: `npm install --global jade pug`.
2. Install gem dependencies: `bundle install`.
3. Finally, run tests: `bundle exec rake test`.
