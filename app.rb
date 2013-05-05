require 'sinatra'
require 'sinatra/partial'
require 'sinatra/static_assets'
require 'sinatra/session'
require 'haml'
require 'less'
require "base64"

class DimiDisk < Sinatra::Base
  load "routes.rb"
end