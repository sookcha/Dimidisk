$(document).on('page:fetch',   function() { NProgress.start(); });
$(document).on('page:change',  function() { NProgress.done(); });
$(document).on('page:restore', function() { NProgress.remove(); });

var ready;
ready = function() {
  console.log("사이트 뜯어보지 마라!");
  $(".manager").hide();
  i = 0;
  filename = "";
  $("li.file").click(function() {
    if ($($(this).children()[0]).is(":checked"))
    {
      $($(this).children()[0]).prop("checked",false);
      i--;
      if (i == 0)
      {
        $(".manager").hide();
      }
    }
    else
    {
      filename = $($(this).children()[2]).children()[0].innerText;
      $($(this).children()[0]).prop("checked",true);
      $(".manager").show();
      console.log(filename);
      var originalSrc = $(".zip").attr('href');
      i++;
    }
    $(".dl-count").empty().append("<span class=count>"+ i + "개 선택됨");
    $(".dl-count").empty().append("<span class=count>"+ i + "개 선택됨");
    $(".zip").attr("href",originalSrc + "/" +filename)
  });
};

$(document).ready(ready);
$(document).on('page:load', ready);
