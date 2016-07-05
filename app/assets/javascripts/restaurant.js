$(document).on("ready page:change", function() {
  $('.upload').change(function(){
    $('#new_picture').submit();
  });
  
  $('.btn-hide-click').click(function(){
    $(this).hide();
  });
  
  $('.datetimepicker').datetimepicker({format:'DD/MM/Y h:mm A'});
});
