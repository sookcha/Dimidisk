Sinatra::Base.get '/' do
  haml :index
end

Sinatra::Base.get '/login' do
  haml :login
end

Sinatra::Base.post '/login' do
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
    'User-Agent' => 'DimiDisk',
  }
  
  resp = http.post(path, data, headers)
  cookies = resp.get_fields('set-cookie')[0].split(/;/)[0].split(/=/)
  cookieValue = cookies[1]
  
  session["JSESSIONID"] = cookieValue
  redirect '/shared'
end

Sinatra::Base.get '/application.css' do
  less(:"../public/application")
end

Sinatra::Base.get '/bootstrap.css' do
  headers["Content-Type"] = "text/css"
  send_file "public/bootstrap.css"
end

Sinatra::Base.get '/flat-ui.css' do
  headers["Content-Type"] = "text/css"
  send_file "public/flat-ui.css"
end

Sinatra::Base.get '../application.css' do
  headers["Content-Type"] = "text/css"
  send_file "public/flat-ui.css"
end

Sinatra::Base.get '../bootstrap.css' do
  headers["Content-Type"] = "text/css"
  send_file "public/bootstrap.css"
end

Sinatra::Base.get '../flat-ui.css' do
  headers["Content-Type"] = "text/css"
  send_file "public/bootstrap.css"
end



Sinatra::Base.get '/shared' do
  diskURL = "http://disk.dimigo.hs.kr:8282/"
  url = URI.parse(diskURL + "ListService.do?id=sharedisk_1404")
  header = {
    "Accept" => "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
    "Connection" => "keep-alive",
    "Referer" => "http://disk.dimigo.hs.kr:8282/index.jsp",
    "Cookie" => "JSESSIONID=" + session["JSESSIONID"],
    'User-Agent' => 'DimiDisk'
  }
  req = Net::HTTP::Get.new(url.path+"?"+url.query,header)
  @res = Net::HTTP.start(url.host, url.port) {|http|
    http.request(req)
  }
  
  document = Nokogiri::XML::Document.parse(@res.body) 
  @names = document.xpath("/rows/row/userdata[3]")
  @ids = document.xpath("/rows/row/userdata[2]")
  
  haml :disk
end

Sinatra::Base.get '/download/:diskid/:fileid/:filename' do
  headers["Content-Type"] = "application/octet-stream"
  headers["Content-Disposition"] = "attachment; filename="+params[:filename]
  
  fileid = params[:fileid]
  diskid = params[:diskid]
  
  http = Net::HTTP.new('disk.dimigo.hs.kr', 8282)
  path = '/WebFileDownloader.do'

  data = "id="+ fileid +"&diskType=sharedisk&diskId=" + diskid
  headers = {
    'Origin' => 'http://disk.dimigo.hs.kr:8282',
    'Accept-Encoding' => 'gzip,deflate',
    'Content-Type' => 'application/x-www-form-urlencoded',
    'Accept' => 'image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, */*',
    'User-Agent' => 'DimiDisk',
    'Cookie' => 'JSESSIONID=' + session["JSESSIONID"]
  }
  
  resp = http.post(path, data, headers).body
end

Sinatra::Base.get '/shared/*' do
  @rawParams = params[:splat].to_s
  @userid = params[:splat].last.split("/").last if params[:splat].last.split("/").last != nil
  diskURL = "http://disk.dimigo.hs.kr:8282/"
  if @rawParams.count("/") < 1
    url = URI.parse(diskURL + "ListService.do?tid=shareuser_"+@userid+"&disktype=none&id=shareuser_"+@userid)
  else
    url = URI.parse(diskURL + "ListService.do?id=folder_"+@userid+"&disktype=none&id=shareuser_"+@userid)
  end
  
  header = {
    "Accept" => "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
    "Connection" => "keep-alive",
    "Referer" => "http://disk.dimigo.hs.kr:8282/index.jsp",
    "Cookie" => "JSESSIONID=" + session["JSESSIONID"],
    'User-Agent' => 'DimiDisk'
  }
  req = Net::HTTP::Get.new(url.path + "?" + url.query,header)
  @res = Net::HTTP.start(url.host, url.port) {|http|
    http.request(req)
  }
    
  document = Nokogiri::XML::Document.parse(@res.body)
  @directoryTypes = document.xpath("/rows/row/userdata[1]")
  @directoryIds = document.xpath("/rows/row/userdata[2]")
  @directoryNames = document.xpath("/rows/row/userdata[3]")
  
  haml :innerDisk
end