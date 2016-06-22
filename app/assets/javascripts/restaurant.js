$(document).ready(function(){
  $('.upload').change(function(){
    $('#new_picture').submit();
  });
  
  $('.btn-hide-click').click(function(){
    $(this).hide();
  })
});