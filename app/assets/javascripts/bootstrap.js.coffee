jQuery ->
  $("a[rel=popover]").popover()
  $(".tooltip").tooltip()
  $("a[rel=tooltip]").tooltip()

$('.carousel').carousel({
  interval: 5000
})

$('#myModal').modal()