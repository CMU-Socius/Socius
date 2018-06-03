$(document).on('ready', function(){
  $(".new_org_link").click(function(){
        $(this).siblings('.alliance-org-form').toggle();
    });

});