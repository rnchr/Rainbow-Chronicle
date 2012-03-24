# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$('.leader-submit').prop('disabled', true);

checkAddress = () ->
 if $('#leader_address').val()?
  $('.leader-submit').prop('disabled', false)
 else
  $('.leader-submit').prop('disabled', true)

$('#leader_address').blur (e) ->
 checkAddress()
