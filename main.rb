require 'sinatra'
require 'sinatra/partial'
require 'sinatra/static_assets'
require 'haml'

get '/' do
  haml :index
end