jQuery(document).ready(function(){
		console.log("사이트 뜯어보지 마라!")
		$("span.right").hide();
		$("ul li").hover(
			    function() {
						$("span.right", this).show();
			    }, function() {
						$("span.right", this).hide();
		});
});