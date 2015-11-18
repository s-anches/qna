# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  $('.edit-question-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    $('.edit_question').show();

  $('.edit-answer-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('id');
    console.log $(this).parent();
    $('form#edit-answer-' + answer_id).show();
