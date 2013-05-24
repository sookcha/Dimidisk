(function($){
	$(function(){
		var postData = "pt=member&member_id_crypt=czIwMTMxNTEz&passwd_crypt=NzQzNnEmcQ=="
			
			$.ajax({
			  url: "http://disk.dimigo.hs.kr:8282/LoginService.do"
			, type: 'POST'
			, contentType: 'application/x-www-form-urlencoded'
			, data: postData
			, success: function(data){ 
				console.log(data);
			},
			error: function(err) {
				console.log(err);
			}
		});
		
		console.log("사이트 뜯어보지 마라!")
	});
}(Zepto))