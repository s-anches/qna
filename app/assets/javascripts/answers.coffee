ready = ->
  $('.edit-answer-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('id')
    $('form#edit_answer_' + answer_id).show()

  $(".answer-like-link").bind "ajax:success", (e, data, status, xhr) ->
    answer_id = $(this).data('id')
    question_id = $(this).data('question-id')
    response = $.parseJSON(xhr.responseText)
    updateAnswerRating(response.rating, answer_id)
    $(".answer-like-link[data-id='" + answer_id + "']").addClass('liked answer-unvote-link')
    .data('method', 'delete')
    .attr('href', '/questions/' + question_id + '/answers/' + answer_id + '/unvote')
    .removeClass('answer-like-link')
    $(".answer-dislike-link[data-id='" + answer_id + "']").addClass 'not-active'
  .bind "ajax:error", (e, xhr, status, error) ->
    response = $.parseJSON(xhr.responseText)
    $.each response, (index, value) ->
      $("#votes").after "<div class='error'>" + value + "</div>"

  $(".answer-dislike-link").bind "ajax:success", (e, data, status, xhr) ->
    answer_id = $(this).data('id')
    question_id = $(this).data('question-id')
    response = $.parseJSON(xhr.responseText)
    updateAnswerRating(response.rating, answer_id)
    $(".answer-dislike-link[data-id='" + answer_id + "']").addClass('disliked answer-unvote-link')
    .data('method', 'delete')
    .attr('href', '/questions/' + question_id + '/answers/' + answer_id + '/unvote')
    .removeClass 'answer-dislike-link'
    $(".answer-like-link[data-id='" + answer_id + "']").addClass 'not-active'
  .bind "ajax:error", (e, xhr, status, error) ->
    response = $.parseJSON(xhr.responseText)
    $.each response, (index, value) ->
      $("#votes").after "<div class='error'>" + value + "</div>"

  $(".answer-unvote-link").bind "ajax:success", (e, data, status, xhr) ->
    answer_id = $(this).data('id')
    question_id = $(this).data('question-id')
    response = $.parseJSON(xhr.responseText)
    updateAnswerRating(response.rating, answer_id)

    $(".liked[data-id='" + answer_id + "'], .answer-like-link[data-id='" + answer_id + "']").addClass('answer-like-link')
    .attr('href', '/questions/' + question_id + '/answers/' + answer_id + '/like')
    .data('method', 'patch')
    .removeClass('liked not-active answer-unvote-link')

    $(".disliked[data-id='" + answer_id + "'], .answer-dislike-link[data-id='" + answer_id + "']").addClass('answer-dislike-link')
    .attr('href', '/questions/' + question_id + '/answers/' + answer_id + '/dislike')
    .data('method', 'patch')
    .removeClass('disliked not-active answer-unvote-link')

  .bind "ajax:error", (e, xhr, status, error) ->
    response = $.parseJSON(xhr.responseText)
    $.each response, (index, value) ->
      $("#votes").after "<div class='error'>" + value + "</div>"

$(document).ready(ready)
$(document).on('page:load', ready)
$(document).on('page:update', ready)

updateAnswerRating = (rating, answer_id) ->
  $(".answer[data-id='" + answer_id + "'] .votes-count").html "Rating: " + rating
