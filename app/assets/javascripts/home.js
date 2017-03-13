$(document).on("ready page:change", function() {

//  alert(1);
  var slideShowDivs = $('.bg')
  var currentID = 0;
  var slideShowTimeout = 15000;


//  alert(123);
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

  $('.home-nav').affix({offset: {top: 600}});
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

  for (var i = 1; i < slideShowDivs.length; i++) $(slideShowDivs[i]).hide();
  setTimeout(slideShowChange, slideShowTimeout);

  function slideShowChange() {
      var nextID = currentID + 1;
      if (nextID >= slideShowDivs.length) nextID = 0;
      $(slideShowDivs[currentID]).stop(true).fadeOut(400);
      $(slideShowDivs[nextID]).stop(true).fadeIn(400, function() {
          setTimeout(slideShowChange, slideShowTimeout);
      });
      currentID = nextID;
  }

});
