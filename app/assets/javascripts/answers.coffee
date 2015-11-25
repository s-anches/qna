ready = ->
  $('.edit-answer-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('id')
    $('form#edit_answer_' + answer_id).show()

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
