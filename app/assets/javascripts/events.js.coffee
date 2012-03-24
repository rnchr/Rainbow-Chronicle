# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$('.event-submit').prop('disabled', true);

checkAddress = () ->
 if $('#event_address').val()?
  $('.event-submit').prop('disabled', false)
 else
  $('.event-submit').prop('disabled', true)

$('#event_address').blur (e) ->
 checkAddress()
