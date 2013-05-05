get '/' do
  haml :index
end

get '/login' do
  haml :login
end

post '/login' do
  
end

get '/disk' do
  haml :disk
end