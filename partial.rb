Sinatra::Base.get '/application.css' do
  less(:"../public/application")
end

Sinatra::Base.get '/1140.css' do
  headers["Content-Type"] = "text/css"
  send_file "public/bootstrap.css"
end

Sinatra::Base.get '/flat-ui.css' do
  headers["Content-Type"] = "text/css"
  send_file "public/flat-ui.css"
end

Sinatra::Base.get '/grid.css' do
  headers["Content-Type"] = "text/css"
  send_file "public/grid.css"
end

Sinatra::Base.get '/intro.jpg' do
  send_file "public/intro.jpg"
end

Sinatra::Base.get '/font.css' do
  headers["Content-Type"] = "text/css"
  send_file "public/font.css"
end

Sinatra::Base.get "/zepto-autocomplete.js" do
  send_file "public/zepto-autocomplete.js"
end

Sinatra::Base.get "/application.js" do
  send_file "public/application.js"
end


Sinatra::Base.get "/zepto.min.js" do
  send_file "public/zepto.min.js"
end

