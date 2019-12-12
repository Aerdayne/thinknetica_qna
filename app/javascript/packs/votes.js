$(document).on('turbolinks:load', function(){
  $('.question').on('ajax:success', function(e) {
    var response = e.detail[0];
    console.log(e.detail[0])
    $('.question').find('.score').html(response.score);
  });

  $('.answers').on('ajax:success', function(e) {
    var response = e.detail[0];
    $("div[data-id='" + response.id + "']").find('.score').html(response.score);
  });
});