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
    $(".hidden-cat").show()