# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$('.place-submit').prop('disabled', true);

checkAddress = () ->
 if $('#place_address').val()?
  $('.place-submit').prop('disabled', false)
 else
  $('.place-submit').prop('disabled', true)

$('#place_address').blur (e) ->
 checkAddress()
