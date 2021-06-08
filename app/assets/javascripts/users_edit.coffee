$(document).ready ->
  console.log 'ajax testing'
  $(".edit_user").on("ajax:success", (e, data, status, xhr) ->
    $("#edit_user").append xhr.responseText
  ).on "ajax:error", (e, xhr, status, error) ->
    $("#edit_user").append "<p>ERROR</p>"