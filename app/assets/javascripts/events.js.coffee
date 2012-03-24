# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$('input[name="commit"]').prop('disabled', true);

checkAddress = () ->
 if $('#event_address').val()?
  $('input[name="commit"]').prop('disabled', false)
 else
  $('input[name="commit"]').prop('disabled', true)

$('#event_address').blur (e) ->
 checkAddress()
