$(document).on('ready', function(){
  $(".filterlink").click(function(){
        $(this).siblings('.filtertable').toggle();
    });

});

$(document).on('ready', function(){
  $(".detail_link").click(function(){
        $(this).parent().siblings('.detail_toggle').each(function(){
        	if ( this.style.display == "block" ) {
		      this.style.display = "none";
		    } else {
		      this.style.display = "block";
		    }
        });
    });

});