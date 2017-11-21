
// Initialize Google Map for adding a new request
function initPostMap() {

    if(!document.getElementById('map-canvas')) return;

    var map = new google.maps.Map(document.getElementById('map-canvas'), {
        zoom: 15,
    });

    map.addListener('click', function() {
        // alert("map clicked");
    });

    var marker;
    var bounds = new google.maps.LatLngBounds();
    var infowindow = new google.maps.InfoWindow({
        boxStyle: {
            background: "white",
            width: "400px"
        },
    });

    var post_details = $('.map_info').data('postDetails');
    for(var i = 0; i < post_details.length; i++) {

        var title = "Request";
        var lat = post_details[i][0]["latitude"];
        var lng = post_details[i][0]["longitude"];
        var coords = new google.maps.LatLng(lat, lng);
        if(i == 0) map.setCenter(coords);

        marker = new google.maps.Marker({
            position: coords,
            label: ""
        });

        marker.setMap(map);
        bounds.extend(coords);

        google.maps.event.addListener(marker, 'click', (function(marker, i) {
            return function() {
                infowindow.setContent(title);
                infowindow.open(map, marker);
            }
        })(marker, i));

    }

    map.fitBounds(bounds);

}

$(document).ready(function() {
    initPostMap();
});
