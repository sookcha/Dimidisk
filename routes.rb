get '/' do
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

  data = "pt=member&member_id_crypt="+ username + "&passwd_crypt=" + password
  headers = {
    'Origin' => 'http://disk.dimigo.hs.kr:8282',
    'Accept-Encoding' => 'gzip,deflate,sdch',
    'Referer' => 'http://disk.dimigo.hs.kr:8282/login.jsp',
    'Content-Type' => 'application/x-www-form-urlencoded',
    'Accept' => 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
    'User-Agent' => 'DimiDiskforChrome',
  }
  
  resp = http.post(path, data, headers)
  cookies = resp.get_fields('set-cookie')[0].split(/;/)[0].split(/=/)
  cookieValue = cookies[1]
  
  session["JSESSIONID"] = cookieValue
  redirect '/disk'
end

get '/application.css' do
  less(:"../public/application")
end

get '/disk' do
  diskURL = "http://disk.dimigo.hs.kr:8282/"
  url = URI.parse(diskURL + "ListService.do?id=sharedisk_1404")
  header = {
    "Accept" => "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
    "Connection" => "keep-alive",
    "Referer" => "http://disk.dimigo.hs.kr:8282/index.jsp",
    "Cookie" => "JSESSIONID="+session["JSESSIONID"],
    'User-Agent' => 'DimiDiskforChrome'
  }
  req = Net::HTTP::Get.new(url.path+"?"+url.query,header)
  @res = Net::HTTP.start(url.host, url.port) {|http|
    http.request(req)
  }

  haml :disk
end