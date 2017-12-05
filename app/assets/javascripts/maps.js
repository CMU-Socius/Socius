
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

function initPostFormMap() {

    // default to Pittsburgh
    var lat = 40.440624;
    var lng = -79.995888;
    var initialCoords = new google.maps.LatLng(lat, lng);

    // init elements
    var map = new google.maps.Map(document.getElementById('map-canvas'), {
        zoom: 15,
        center: initialCoords
    });

    var marker = new google.maps.Marker({
        position: initialCoords,
        label: "",
        // info: infoContent
    });

    var infowindow = new google.maps.InfoWindow();

    // set props
    marker.setMap(map);

    map.addListener('click', function(event) {
        lat = event.latLng.lat();
        lng = event.latLng.lng();
        marker.setPosition(new google.maps.LatLng(lat, lng));
        infowindow.open(map, marker);
    });

    var infoContent = 
    '<div class="infoWindow">'+
        '<div id="content">'+
            '<a>Select Position</a>'
        '</div>' +
    '</div>';

    infowindow.setContent(infoContent);

    var geocoder = new google.maps.Geocoder;

    google.maps.event.addListener(infowindow, 'domready', function() {
        $(".infoWindow a").on("click", function() {
            var latLng = marker.getPosition();
            // get address
            geocoder.geocode({"location": latLng}, function(results, status) {
                if(status === "OK" && results[0] !== null) {
                    // find address from latlng and break it down into components
                    var address_components = results[0].address_components;
                    var street_1 = "", // STREET 1: street_number.long_name + " " + route.long_name
                        street_2 = "", // STREET 2: 
                        city     = "", // CITY: locality.long_name 
                        state    = "", // STATE: administrative_area_level_1.short_name 
                        zip      = ""; // ZIP: postal_code.long_name
                    for(var i = 0; i < address_components.length; i++) {
                        var types = address_components[i].types;
                        if(types.indexOf("street_number") >= 0) street_1 = address_components[i].long_name + " " + street_1;
                        if(types.indexOf("route") >= 0) street_1 += address_components[i].long_name;
                        if(types.indexOf("locality") >= 0) city = address_components[i].long_name;
                        if(types.indexOf("administrative_area_level_1") >= 0) state = address_components[i].short_name;
                        if(types.indexOf("postal_code") >= 0) zip = address_components[i].long_name;
                    }
                    // set values of hidden address inputs
                    $("input[name='post[street_1]']").val(street_1);
                    $("input[name='post[street_2]']").val(street_2);
                    $("input[name='post[city]']").val(city);
                    $("input[name='post[state]']").val(state);
                    $("input[name='post[zip]']").val(zip);

                    // move to next section
                    index = 1;
                    shiftForm(index);
                } else {
                    // alert user and don't do anything
                    alert("Google Maps failed to find an address for this point. Try another point.")
                }
            });
        });
    });
    infowindow.open(map, marker);

    google.maps.event.addListener(marker, 'click', (function(marker) {
        return function() {
            infowindow.open(map, marker);
        }
    })(marker));

}

