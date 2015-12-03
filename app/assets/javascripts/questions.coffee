ready = ->

  $('.edit-question-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    $('.question').hide();
    $('.question-edit').show();

  $(".question-like-link").bind "ajax:success", (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)
    updateRating(response.rating)
    $('.question-like-link').addClass('liked question-unvote-link')
    .data('method', 'delete')
    .attr('href', '/questions/' + response.object + '/unvote')
    .removeClass('question-like-link')
    $('.question-dislike-link').addClass 'not-active'
  .bind "ajax:error", (e, xhr, status, error) ->
    response = $.parseJSON(xhr.responseText)
    $.each response, (index, value) ->
      $("#votes").after "<div class='error'>" + value + "</div>"

  $(".question-dislike-link").bind "ajax:success", (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)
    updateRating(response.rating)
    $(".question-dislike-link").addClass('disliked question-unvote-link')
    .data('method', 'delete')
    .attr('href', '/questions/' + response.object + '/unvote')
    .removeClass 'question-dislike-link'
    $('.question-like-link').addClass 'not-active'
  .bind "ajax:error", (e, xhr, status, error) ->
    response = $.parseJSON(xhr.responseText)
    $.each response, (index, value) ->
      $("#votes").after "<div class='error'>" + value + "</div>"

  $(".question-unvote-link").bind "ajax:success", (e, data, status, xhr) ->
    response = $.parseJSON(xhr.responseText)
    updateRating(response.rating)

    $('.liked, .question-like-link').addClass('question-like-link')
    .attr('href', '/questions/' + response.object + '/like')
    .data('method', 'patch')
    .removeClass('liked not-active question-unvote-link')

    $('.disliked, .question-dislike-link').addClass('question-dislike-link')
    .attr('href', '/questions/' + response.object + '/dislike')
    .data('method', 'patch')
    .removeClass('disliked not-active question-unvote-link')

  .bind "ajax:error", (e, xhr, status, error) ->
    response = $.parseJSON(xhr.responseText)
    $.each response, (index, value) ->
      $("#votes").after "<div class='error'>" + value + "</div>"

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)

updateRating = (rating) ->
  $(".question .votes-count").html "Rating: " + rating
