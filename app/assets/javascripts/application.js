// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs


//= require bootstrap-sprockets
//= require underscore

//= require maps

//= require_tree .

$( document ).ready(function() {
    console.log( "ready!" );
});

$(document).on('ready page:load', function() {
    console.log('toggle')
    var toggled = false;
    console.log('toggled = ', toggled)
  $('[data-toggle=offcanvas]').click(function() {
    if(toggled==true){
        console.log('open')
        $('.row').toggleClass('active');
        toggled = false;
    }

    else {
        console.log('close')
        toggled = true
        $('.row').toggleClass('active');
    }
 
   
  });



});


