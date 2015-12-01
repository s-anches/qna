ready = ->
  $('.edit-question-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    $('.question').hide();
    $('.question-edit').show();

  $("#question_like_link").bind "ajax:success", (e, data, status, xhr) ->
      response = $.parseJSON(xhr.responseText)
      $("#votes").html "Votes: #{xhr.responseText}"
    .bind "ajax:error", (e, xhr, status, error) ->
      response = $.parseJSON(xhr.responseText)
      $.each response, (index, value) ->
        $("#votes").after "<div class='error'>" + value + "</div>"

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
