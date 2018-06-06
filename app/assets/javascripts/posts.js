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

$(document).on('ready', function(){
  $(".comment_link").click(function(){
        $(this).siblings('.comment_form').toggle();
    });

});

$(document).on('ready', function(){
  $(".hide_link").click(function(){
        $(this).siblings('.comments').toggle();
    });

});