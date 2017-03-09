$(document).ready(function() {
  $("#viewer").click(function(event){
    var class_name = $(event.target).attr('class')
    if (! ['nav-next', 'nav-previous', 'toggle'].includes(class_name)) {
      if ($('.caption').is(':hidden')) {
        $('.inner').fadeIn()
        $('.caption').fadeIn()
      } else {
        $('.inner').fadeOut()
        $('.caption').fadeOut()
      }
    }
  });
});
