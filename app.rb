require "sinatra"
require "sinatra/partial"
require "sinatra/static_assets"
require "rack/session/file"
require "haml"
require "less"
require "base64"
require "net/http"
require "uri"
require "nokogiri"

class DimiDisk < Sinatra::Base
  use Rack::Session::File, :storage => ENV['TEMP'],
                           :expire_after => 1800
  
  load "routes.rb"
end
