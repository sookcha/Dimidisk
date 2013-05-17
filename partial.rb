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

Sinatra::Base.get '/intro.png' do
  send_file "public/intro.png"
end

Sinatra::Base.get '/font.css' do
  headers["Content-Type"] = "text/css"
  send_file "public/font.css"
end