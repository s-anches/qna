ready = ->
  $('.edit-answer-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('id')
    $('form#edit_answer_' + answer_id).show()

  $('.answer-like-link').bind "ajax:success", (e, data, status, xhr) ->
    e.preventDefault();
    answer_id = $(this).data('id')
    response = $.parseJSON(xhr.responseText)
    $('#answer-votes-' + answer_id + ' p').html "Votes: #{xhr.responseText}"
  .bind "ajax:error", (e, xhr, status, error) ->
    response = $.parseJSON(xhr.responseText)
    $.each response, (index, value) ->
      $('#answer-votes-' + answer_id + ' p').append "<p>ERROR</p>"

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
