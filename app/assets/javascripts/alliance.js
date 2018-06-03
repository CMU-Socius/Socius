$(document).on('ready', function(){
  $(".new_link").click(function(){
        $(this).siblings('.org-form').toggle();
    });

});