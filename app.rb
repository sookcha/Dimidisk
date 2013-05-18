require "sinatra"
require 'sinatra/base'
require "sinatra/partial"
require "sinatra/session"
require "sinatra/static_assets"
require "rack/session/file"
require "haml"
require "less"
require "base64"
require "redcarpet"
require "net/http"
require "uri"
require "nokogiri"

class DimiDisk < Sinatra::Base
	configure :production do
  	require 'newrelic_rpm'
	end

  use Rack::Session::File, :storage => ENV['TEMP'],
                           :expire_after => 1800
                           
  load "routes.rb"
  load "partial.rb"
end
