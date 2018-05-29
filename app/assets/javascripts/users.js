$(function(){
	$("#profile-tabs-nav a[data-target]").click(function() {
		
		// update nav
		var target = this.dataset.target;
		var navLinks = $("#profile-tabs-nav a[data-target]");
		for (var i = 0; i < navLinks.length; i++) {
			$(navLinks[i]).addClass("inactive");
		}
		$("a[data-target=" + target + "]").removeClass("inactive");

		// update content
		var target = "#profile-" + this.dataset.target;
		var contentDivs = $("#profile-tabs-content > div");
		for (var i = 0; i < contentDivs.length; i++) {
			$(contentDivs[i]).addClass("inactive");
		}
		$(target).removeClass("inactive");
	});
});

$(function(){
	$("#user-tabs-nav a[data-target]").click(function() {
		var target = this.dataset.target;
		var navLinks = $("#user-tabs-nav a[data-target]");
		for (var i = 0; i < navLinks.length; i++) {
			$(navLinks[i]).addClass("inactive");
		}
		$("a[data-target=" + target + "]").removeClass("inactive");

		// update content
		var target = "#user-" + this.dataset.target;
		var contentDivs = $("#user-tabs-content > div");
		for (var i = 0; i < contentDivs.length; i++) {
			$(contentDivs[i]).addClass("inactive");
		}
		$(target).removeClass("inactive");
	});
});



