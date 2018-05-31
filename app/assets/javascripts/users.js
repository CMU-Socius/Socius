
$(function(){
	$(".general-tabs-nav a[data-target]").click(function() {
		var target = this.dataset.target;
		var navLinks = $(".general-tabs-nav a[data-target]");
		for (var i = 0; i < navLinks.length; i++) {
			$(navLinks[i]).addClass("inactive");
		}
		$("a[data-target=" + target + "]").removeClass("inactive");

		// update content
		var target = "#" + this.dataset.target;
		var contentDivs = $(".general-tabs-content > div");
		for (var i = 0; i < contentDivs.length; i++) {
			$(contentDivs[i]).addClass("inactive");
		}
		$(target).removeClass("inactive");
	});
});



