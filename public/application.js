$(document).on('page:fetch',   function() { NProgress.start(); });
$(document).on('page:change',  function() { NProgress.done(); });
$(document).on('page:restore', function() { NProgress.remove(); });

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