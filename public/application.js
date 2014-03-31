$(document).on('page:fetch',   function() { NProgress.start(); });
$(document).on('page:change',  function() { NProgress.done(); });
$(document).on('page:restore', function() { NProgress.remove(); });

$("document").ready(function() {
    console.log("사이트 뜯어보지 마라!");
    $(".manager").hide();
    $("li.file").click(function() {
      if ($($(this).children()[0]).is(":checked"))
      {
        $($(this).children()[0]).prop("checked",false);
        $(".manager").hide();
      }
      else
      {
        $($(this).children()[0]).prop("checked",true);
        $(".manager").show();
      }
    });
});
