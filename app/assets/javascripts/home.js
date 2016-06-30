$(document).on("ready page:change", function() {
  $(".owl-carousel").owlCarousel({
    singleItem: true
  });
  
  $('#filter_search_button').click(function(e){
    e.preventDefault();
    $('#filter_search_field').val($('#search_field').val());
    $('#filter_search_form').submit();
  })
  
  $("#price_slider").slider({
    step: 1
  });
  
  var jumboHeight = $('.jumbotron').outerHeight();
  function parallax(){
      var scrolled = $(window).scrollTop();
      $('.bg').css('height', (jumboHeight-scrolled) + 'px');
  }

  $(window).scroll(function(e){
      parallax();
  });
});