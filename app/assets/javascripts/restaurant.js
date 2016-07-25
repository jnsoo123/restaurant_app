$(document).on("ready page:change", function() {
  $('.upload').change(function(){
    $('#new_picture').submit();
  });
  
  $('.btn-hide-click').click(function(){
    $(this).hide();
  });
  
  $('[data-toggle="tooltip"]').tooltip();

});
