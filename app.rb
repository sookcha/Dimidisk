require 'sinatra'
require 'sinatra/partial'
require 'sinatra/static_assets'
require 'sinatra/cross_origin'
require 'haml'
require 'less'

class DimiDisk < Sinatra::Base  
  load "routes.rb"
end