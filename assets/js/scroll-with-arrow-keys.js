var calculateScrollTopLocked = false

function setScrollTops() {
  if (! calculateScrollTopLocked) {
    calculateScrollTopLocked = true
    $('#abroad-photos li').each(function(i, v) {
      /* distance to scroll to this img is offsetTop
       * MINUS half the leftover space at the bottom (distance
       * from bottom of image to bottom of screen) in order to
       * center it */
      scrollTop = this.offsetTop
      scrollTop -= Math.max(0, ($(window).height() - $(this).outerHeight())/2)
      scrollTop = Math.floor(scrollTop)
      $(this).data('scrollTop', scrollTop)
    });
    calculateScrollTopLocked = false
  }
}

$(document).ready(function() {
  setScrollTops()
  $('#abroad-photos ul').imagesLoaded(setScrollTops)
  window.onresize = setScrollTops

  $(document).keydown(function(e) {
    var dir = false,
    targetTop = -1;

    switch (e.keyCode) {
      case 37:
      case 38:
          dir = -1;
          break;
      case 39:
      case 40:
          dir = 1;
          break;
    }

    if (dir) {
      e.preventDefault();
      winTop = window.scrollY;
      $('#abroad-photos li').each(function(i, elem) {
        scrollTop = $(elem).data('scrollTop')
        if ((dir == 1 && winTop < scrollTop && targetTop < 0) ||
          (dir == -1 && winTop > scrollTop)) {
          targetTop = scrollTop;
        }
      })
      if (targetTop >= 0) {
        window.scrollTo(window.scrollX, targetTop)
      } else if (dir == -1) {
        window.scrollTo(0,0)
      }
    }
  });
});
