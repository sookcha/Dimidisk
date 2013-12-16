$(document).on "page:fetch", ->
  NProgress.start()

$(document).on "page:change", ->
  NProgress.done()

$(document).on "page:restore", ->
  NProgress.remove()

jQuery(document).ready ->
  console.log "사이트 뜯어보지 마라!"
  $("span.right").hide()
  $("ul li").hover (->
    $("span.right", this).show()
  ), ->
    $("span.right", this).hide()