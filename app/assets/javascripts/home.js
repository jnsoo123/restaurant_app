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
  
  
});