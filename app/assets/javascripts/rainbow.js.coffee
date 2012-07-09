$(".slider").slider
    min: -5
    max: 5
    slide: (event, ui) ->
        id = $(this).attr("id");
        $("#rating-#{id}").val(ui.value);
        $("#label-#{id}").text(ui.value);
        console.log "rating-#{id}"

$("#show-state").click (e) ->
    console.log "click"
    $("#nearby-cities").toggle()
    $("#all-cities").toggle()
    
$("#show-nearby").click (e) ->
    $("#nearby-cities").toggle()
    $("#all-cities").toggle()

$("#show-all-cats").click (e) ->
    console.log "clicked"
    $(".hidden-cat").toggle()

geocode_it = (addr_id) ->
    geocoder = new google.maps.Geocoder
    geocoder.geocode { address: $("##{addr_id}").val() }, (result, status) ->
        if (result.length > 0) 
            Gmaps.map.map.setCenter result[0].geometry.location
            window.res = result
            $("#set_lat").val(result[0].geometry.location.Xa)
            $("#set_lng").val(result[0].geometry.location.Ya)
            $("#geocoded").val("true")
            $("#set_state").val(res[0].address_components[res[0].address_components.length-2].short_name)
        else alert("Sorry, we couldn't understand that.")

$("#locate_me").submit (e) ->
    unless $("#geocoded").val() == "true"
        geocode_it('location')
        e.preventDefault()
    else return true

$("#find").click (e) ->
    geocode_it('location')
    $("#locate_me").submit()
