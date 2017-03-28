$(document).ready(function() {
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
});
