/* Floating back-to-top button */

function backToTop() {
  $('body').prepend('<a href="#" class="back-to-top">Back to Top</a>');

  var amountScrolled = 300;

  locked = false

  $(window).scroll(function() {
    if (! locked) {
      locked = true
      if ( $(window).scrollTop() > amountScrolled ) {
        $('a.back-to-top').fadeIn('slow');
      } else {
        $('a.back-to-top').fadeOut('slow');
      }
      locked = false
    }
  });

  $('a.back-to-top').click(function() {
    window.scrollTo(0,0)
    return false;
  });
}

/* Scrolling through pics with arrow keys */

var calculateScrollTopLocked = false
function setScrollTops() {
  if (! calculateScrollTopLocked) {
    calculateScrollTopLocked = true
    $('#abroad-photos li').each(function(i, v) {
      /* distance to scroll to this img is offsetTop MINUS half the leftover
       * space at the bottom (distance from bottom of image to bottom of
       * screen) in order to center it */
      scrollTop = this.offsetTop
      leftoverSpace = ($(window).height() - $(this).outerHeight()) / 2
      scrollTop -= Math.max(0, leftoverSpace)
      scrollTop = Math.floor(scrollTop)
      $(this).data('scrollTop', scrollTop)
    });
    calculateScrollTopLocked = false
  }
}

function scrollWithArrowKeys(_callback) {
  /* only show loading message if it's been half a second and the images still
   * haven't loaded */
  var imagesAreLoaded = false
  setTimeout(function() {
    if ( ! imagesAreLoaded) {
      $("#abroad-photos .loading").show()

      /* animate the ellipsis in Loading -> Loading.
       *                                 -> Loading..
       *                                 -> Loading...
       *                                 -> Loading
       */
      var numDots = 0;
      setInterval(function(){
        numDots++;
        html = "Loading" + new Array((numDots % 4) + 1).join('.')
        $("#abroad-photos .loading i").html(html)
      }, 500);
    }
  }, 500);

  function loadedImages() {
    imagesAreLoaded = true
    $("#abroad-photos .loading").hide()
    $("#abroad-photos .wait-for-images").show()
    setScrollTops()
    _callback()
  }

  $('#abroad-photos ul').imagesLoaded(loadedImages)

  /* when done resizing window, setScrollTops */
  var resizeId;
  $(window).resize(function() {
      clearTimeout(resizeId);
      resizeId = setTimeout(setScrollTops, 500);
  });

  /* handle arrow keys to nagivate images.
   * inspired by: http://stackoverflow.com/a/9827123
   */
  $(document).keydown(function(e) {
    var dir = 0
    targetTop = -1;

    switch (e.keyCode) {
      case 37: /* left arrow */
      case 38: /* up arrow */
          dir = -1; /* user wants to move backwards */
          break;
      case 39: /* right arrow */
      case 40: /* down arrow */
          dir = 1; /* user wants to move forwards */
          break;
    }

    if (dir != 0) {
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
}

/* build "jump to month" select */

function buildMonthSelect() {
  months = new Set()
  $("#abroad-photos li").each(function(i, elem) {
    date = Date.parse($(elem).data('date'))
    date_str = date.getMonthName() + " " + date.getFullYear()
    if (! months.has(date_str)) {
      months.add(date_str)
      scrollTop = $(elem).data('scrollTop')
      html = '<option value=' + scrollTop + '>' + date_str + '</option>'
      $("#jump-to-month").append(html)
    }
  })
}


/* highlights toggle-button */

function setupToggleHighlights() {
  $("#toggle-highlights").data("showing-all", true)
  $("#toggle-highlights").text("Show Highlights")

  $("#toggle-highlights").click(function (){
    var showing_all = $(this).data("showing-all")
    if (showing_all) {
      $("#toggle-highlights").text("Show All")
    } else {
      $("#toggle-highlights").text("Show Highlights")
    }
    $("ul#photos li:not(.highlight)").toggle()
    $(this).data("showing-all", !showing_all)
  })

}


/* main program */

$(document).ready(function() {
  backToTop()
  setupToggleHighlights()
  scrollWithArrowKeys(buildMonthSelect)
})
