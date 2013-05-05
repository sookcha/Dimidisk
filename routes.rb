get '/' do
  puts session["JSESSIONID"]
  haml :index
end

get '/login' do
  haml :login
end

post '/login' do
  http = Net::HTTP.new('disk.dimigo.hs.kr', 8282)
  path = '/LoginService.do'

  username = Base64.encode64(params[:username])
  password = Base64.encode64(params[:password])

  @data = "pt=member&member_id_crypt="+ username + "&passwd_crypt=" + password
  headers = {
    'Origin' => 'http://disk.dimigo.hs.kr:8282',
    'Accept-Encoding' => 'gzip,deflate,sdch',
    'Referer' => 'http://disk.dimigo.hs.kr:8282/login.jsp',
    'Content-Type' => 'application/x-www-form-urlencoded',
    'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
    'User-Agent' => 'DimiDiskforChrome'
  }
  
  @resp, @data = http.post(path, @data, headers)
  @cookies = @resp.get_fields('set-cookie')[0].split(/;/)[0].split(/=/)
  @cookieName = @cookies[0]
  @cookieValue = @cookies[1]
  
  session["JSESSIONID"] = @cookieValue
  redirect '/disk'
  #haml :result
end

get '/disk' do
  haml :disk
end