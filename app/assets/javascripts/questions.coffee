ready = ->
  $('.edit-question-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    $('.question').hide();
    $('.question-edit').show();

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)
