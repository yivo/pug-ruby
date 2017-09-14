# encoding: UTF-8
# frozen_string_literal: true

require "pug-ruby"

Jade.use :system

puts Jade.compile "div Hello, Jade!"
# => "<div>Hello, Jade!</div>"

puts Jade.compile "div=greeting", locals: { greeting: "Hello, Jade!" }
# => "<div>Hello, Jade!</div>"

puts Jade.compile "div Hello, Jade!", client: true
# => "(function(jade) { function template(locals) {var buf = []; var jade_mixins = {}; var jade_interp; buf.push("<div>Hello, Jade!</div>");;return buf.join("");}; return template; }).call(this, jade);"

require "pug-ruby"

Pug.use :system

puts Pug.compile "div Hello, Pug!"
# => "<div>Hello, Pug!</div>"

puts Pug.compile "div=greeting", locals: { greeting: "Hello, Pug!" }
# => "<div>Hello, Pug!</div>"

puts Pug.compile "div Hello, Pug!", client: true
# => "(function() { function template(locals) {var pug_html = "", pug_mixins = {}, pug_interp;pug_html = pug_html + "\u003Cdiv\u003EHello, Pug!\u003C\u002Fdiv\u003E";;return pug_html;}; return template; }).call(this);"
