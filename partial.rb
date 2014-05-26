Sinatra::Base.get '/application.css' do
  less(:"../public/application")
end

Sinatra::Base.get '/grid.css' do
  headers["Content-Type"] = "text/css"
  send_file "vendor/grid.css"
end

Sinatra::Base.get '/intro.jpg' do
  send_file "public/intro.jpg"
end

Sinatra::Base.get '/font.css' do
  headers["Content-Type"] = "text/css"
  send_file "public/font.css"
end

Sinatra::Base.get "/zepto-autocomplete.js" do
  send_file "vendor/zepto-autocomplete.js"
end

Sinatra::Base.get "/application.js" do
  send_file "public/application.js"
end

Sinatra::Base.get "/about.css" do
  less(:"../public/about")
end


Sinatra::Base.get "/jquery-1.10.2.min.js" do
  send_file "vendor/jquery-1.10.2.min.js"
end

Sinatra::Base.get "/nprogress.css" do
  send_file "vendor/nprogress.css"
end

Sinatra::Base.get "/nprogress.js" do
  send_file "vendor/nprogress.js"
end

Sinatra::Base.get "/dimidisk-less.mp4" do
  send_file "vendor/dimidisk-less.mp4"
end

Sinatra::Base.get "/turbolinks.js" do
  send_file "vendor/turbolinks.js"
end
