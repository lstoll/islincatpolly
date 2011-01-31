require 'rubygems'
require 'bundler'

Bundler.require

use Rack::Static, :urls => ['/stylesheets'], :root => 'public'

require './app'
run App
