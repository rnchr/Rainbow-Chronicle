$(".slider").slider
    min: -5
    max: 5
    slide: (event, ui) ->
        id = $(this).attr("id");
        $("#rating-#{id}").val(ui.value);
        $("#label-#{id}").text(ui.value);
        console.log "rating-#{id}"
    