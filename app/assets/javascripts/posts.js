$(function(){
	var index = 0;
  $('.post-form-next-button').click(function() {
  	index += 1;
  	shiftForm(index);
  });
  $('.post-form-prev-button').click(function() {
  	index -= 1;
  	shiftForm(index);
  });
  $('.navLink').click(function() {
  	// index = parseInt($(this).find('span').html()) - 1;
  	index = $(".navLink").index(this);
  	shiftForm(index);
  });
});

function shiftForm(index) {

	// shift form
	var form = $('#post-form')[0];
	form.style.webkitTransform = 'translate(-' + (100 * index) + 'vw)';
	form.style.MozTransform = 'translate(-' + (100 * index) + 'vw)';
	form.style.msTransform = 'translate(-' + (100 * index) + 'vw)';
	form.style.OTransform = 'translate(-' + (100 * index) + 'vw)';
	form.style.transform = 'translate(-' + (100 * index) + 'vw)';

	// update nav
	var navLinks = $('.navLink');
	for(var i = 0; i < navLinks.length; i++) {
		if(i == index) $(navLinks[i]).removeClass('inactive');
		else $(navLinks[i]).addClass('inactive');
	}
}