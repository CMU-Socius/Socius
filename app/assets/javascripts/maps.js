
// Initialize Google Map for adding a new request
function initIndexMap() {

    var map = new google.maps.Map(document.getElementById('map-canvas'), {
        zoom: 15,
    });

    map.addListener('click', function() {
        // alert("map clicked");
    });

    var marker;
    var bounds = new google.maps.LatLngBounds();
    var infowindow = new google.maps.InfoWindow();

    var post_details = $('.map_info').data('postDetails');
    for(var i = 0; i < post_details.length; i++) {

        var post = post_details[i];

        var lat = post["lat"];
        var lng = post["lng"];
        var coords = new google.maps.LatLng(lat, lng);
        if(i == 0) map.setCenter(coords);

        var infoContent = 
        '<div class="infoWindow">'+
            '<div id="content">'+
                '<h4>'+ post["street_1"] + '</h4>' +
                '<a target="_blank" href="/posts/' + post["id"] + '">View Details</a>' +
            '</div>' +
        '</div>';

        marker = new google.maps.Marker({
            position: coords,
            label: "",
            info: infoContent
        });

        marker.setMap(map);
        bounds.extend(coords);

        google.maps.event.addListener(marker, 'click', (function(marker, i) {
            return function() {
                infowindow.setContent(marker.info);
                infowindow.open(map, marker);
            }
        })(marker, i));

    }

    map.fitBounds(bounds);

}

function initPostMap() {
    var map = new google.maps.Map(document.getElementById('map-canvas'), {
        zoom: 15,
    });

    map.addListener('click', function() {
        // alert("map clicked");
    });

    var marker;
    var infowindow = new google.maps.InfoWindow();

    var post_details = $('.map_info').data('postDetails');
    
    var post = post_details[0];

    var lat = post["lat"];
    var lng = post["lng"];
    var coords = new google.maps.LatLng(lat, lng);
    map.setCenter(coords);

    var infoContent = 
    '<div class="infoWindow">'+
        '<div id="content">'+
            '<h4>'+ post["street_1"] + '</h4>' +
            '<a href="/posts/' + post["id"] + '/edit">Edit Address</a>' +
        '</div>' +
    '</div>';

    marker = new google.maps.Marker({
        position: coords,
        label: "",
        info: infoContent
    });

    marker.setMap(map);
    infowindow.setContent(marker.info);
    infowindow.open(map, marker);

    google.maps.event.addListener(marker, 'click', (function(marker) {
        return function() {
            infowindow.setContent(marker.info);
            infowindow.open(map, marker);
        }
    })(marker));

}
