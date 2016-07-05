$(document).on("ready page:change", function() {
  $(".owl-carousel").owlCarousel({
    singleItem: true
  });
  
  $('.datetimepicker').datetimepicker({format:'DD/MM/Y h:mm A'});
  
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
  
  $('.home-nav').affix({offset: {top: 620}});
  $('.home-nav').on('affixed.bs.affix', function(){
    var animationEnd = 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend';
    $(this).addClass('animated slideInDown').one(animationEnd, function(){
      $(this).removeClass('animated slideInDown')
    })
  });
  
  setTimeout(function () {
    $(".alert").hide('blind', {}, 50);
  }, 5000);
  
  $(function() {
    $('a[href*="#"]:not([href="#"])').click(function() {
      if (location.pathname.replace(/^\//,'') == this.pathname.replace(/^\//,'') && location.hostname == this.hostname) {
        var target = $(this.hash);
        target = target.length ? target : $('[name=' + this.hash.slice(1) +']');
        if (target.length) {
          $('html, body').animate({
            scrollTop: target.offset().top - 50
          }, 1000);
          return false;
        }
      }
    });
  });
});