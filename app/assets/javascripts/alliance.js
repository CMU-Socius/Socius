$(document).on('ready', function(){
  $(".new_link").click(function(){
        $(this).siblings('.org-form').toggle();
    });

});


$(document).on('ready', function(){
  $(".dlink").click(function(){
        $(this).siblings('.details').each(function(){
        	if ( this.style.display == "inline-block" ) {
		      this.style.display = "none";
		    } else {
		      this.style.display = "inline-block";
		    }
        });
    });


});