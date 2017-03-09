$(document).ready(function() {
  $("#viewer").click(function(event){
    var class_name = $(event.target).attr('class')
    if (! ['nav-next', 'nav-previous', 'toggle'].includes(class_name)) {
      $(this).find('.caption').fadeToggle()
      $(this).find('.inner').fadeToggle()
    }
  });
});
