$(document).ready(function(){
	$.ajax({
	  type: 'POST',
	  url: '',
	  // post payload:
	  data: JSON.stringify({ name: 'Zepto.js' }),
	  contentType: 'application/json'
	})
	
});