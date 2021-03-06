Sinatra::Base.get '/' do
  @session = session["JSESSIONID"]
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

Sinatra::Base.get '/logout' do
  session["JSESSIONID"] = nil
  redirect '/'
end

Sinatra::Base.get '/shared' do
  if session["JSESSIONID"] == nil
    redirect "/login"
  end
  diskURL = "http://disk.dimigo.hs.kr:8282/"
  url = URI.parse(diskURL + "ListService.do?id=sharedisk_1111")
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
  if session["JSESSIONID"] == nil
    redirect "/login"
  end
  
  headers["Content-Disposition"] = "attachment; filename="+params[:filename]
  headers["Content-Type"] = "application/octet-stream"

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
  
  if http.post(path, data, headers).body.to_s.include? '<result code="-1000"'
    redirect "/error/-1000"
  else
    resp = http.post(path, data, headers).body
  end
  
end

Sinatra::Base.get '/upload/:diskid' do
  @diskid = params[:diskid]
  haml :upload
end

Sinatra::Base.get '/error/:code' do
  haml :error
end



Sinatra::Base.post '/upload/:diskid' do
  if session["JSESSIONID"] == nil
    redirect "/login"
  end

  tempfile = params[:file][:tempfile]
  name = params[:file][:filename]

  diskid = params[:diskid]
  http = Net::HTTP.new('disk.dimigo.hs.kr', 8282)
  path = '/TransferService.do'

  headers = {
    'Origin' => 'http://disk.dimigo.hs.kr:8282',
    'Accept' => '*/*',
    'Content-Type' => 'application/x-www-form-urlencoded;charset=UTF-8',
    'User-Agent' => 'DimiDisk',
    "Content-Length" => tempfile.open.read.size.to_s,
    "VANDI-COMMAND" => "upload",
    "VANDI-FILENAME" => name,
    "VANDI-PID" => diskid,
    "VANDI-FILESIZE" => tempfile.open.read.size.to_s,
    "VANDI-USERID" => "1111",
    'Cookie' => 'JSESSIONID=' + session["JSESSIONID"]
  }
  resp = http.post(path,tempfile.open.read, headers).body
end

Sinatra::Base.get '/zip/:diskid' do
  headers["Content-Type"] = "application/octet-stream"
  headers["Content-Disposition"] = "attachment; filename="+params[:filename]

  @files = params[:files].split(",")
  @diskid = params[:diskid]

  http = Net::HTTP.new('disk.dimigo.hs.kr', 8282)
  path = '/WebFileDownloader.do'

  headers = {
    'Origin' => 'http://disk.dimigo.hs.kr:8282',
    'Accept-Encoding' => 'gzip,deflate',
    'Content-Type' => 'application/x-www-form-urlencoded',
    'Accept' => 'image/gif, image/x-xbitmap, image/jpeg, image/pjpeg, */*',
    'User-Agent' => 'DimiDisk',
    'Cookie' => 'JSESSIONID=' + session["JSESSIONID"]
  }

  @files.each do |file|
    @fileid = file.split("/")[1]
    @data = "id="+ @fileid +"&diskType=sharedisk&diskId=" + @diskid
    resp = http.post(path, @data, headers).body
  end

  haml :zip
end

Sinatra::Base.get '/about' do
  haml :about
end


Sinatra::Base.get '/shared/*' do
  if session["JSESSIONID"] == nil
      redirect "/login"
    end
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

  @directory = document.xpath("/rows/row/userdata")
  @directoryTypes = document.xpath("/rows/row/userdata[1]")
  @directoryIds = document.xpath("/rows/row/userdata[2]")
  @directoryNames = document.xpath("/rows/row/userdata[3]")

  @fileSize = document.xpath("/rows/row/cell[3]")
  @fileDate = document.xpath("/rows/row/cell[7]")
  haml :innerDisk
end
