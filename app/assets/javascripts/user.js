$(document).on("ready page:change", function() {
  $('#user-tabs a').click(function (e) {
    e.preventDefault()
    $(this).tab('show')
  })
});