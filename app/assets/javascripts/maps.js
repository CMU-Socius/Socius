// Called by google maps API when main script finishes loading
var map;
var marker;
var markers = [];
var lat = null;
var lng = null;
var latLngInput = null;
var address =  null;
var addArray = [];


// Initialize Google Map for adding a new request
function initPostMap() {
    var pitt = {lat: 40.4415031, lng: -80.0096409};

    var map = new google.maps.Map(document.getElementById('map'), {
        zoom: 15,
        center: pitt
    });

    var marker = new google.maps.Marker({
        position: pitt,
        map: map,
        draggable: true
    });

    marker.addListener('click', function() {
        $('#new-post-form').show()
    })


    latLngInput = marker.getPosition();
    console.log('initial latlng', latLngInput)

    var geocoder = new google.maps.Geocoder;



    google.maps.event.addListener(marker, 'dragend', function(evt){
        lat = evt.latLng.lat()
        latLngInput = {lat: lat, lng: lng}
    });

    google.maps.event.addListener(marker, 'dragstart', function(evt){
        lng = evt.latLng.lng()
        latLngInput = {lat: lat, lng: lng}
        geocodeLatLng(geocoder,map, latLngInput)
    });

    map.setCenter(marker.position);
    marker.setMap(map);
    geocodeLatLng(geocoder, map, latLngInput)




}

//Reverse geocode
function geocodeLatLng(geocoder, map, latLngInput){
    console.log('in geocodelatlng', latLngInput)
    var input = latLngInput
    geocoder.geocode({'location': input}, function(results, status){
        if (status === 'OK') {
            if(results[0]) {
                address = results[0]
                console.log(address)
                // addArray = address.split(',')
            }
            fillAddressField(address)
        }
    })

}

function fillAddressField(address) {
    var street_1 = ""
    var street_2 = ""
    var city = ""
    var state = ""
    var zip = ""

    console.log('filling address field', address)
    $.each(address.address_components, function(i, field) {
        console.log('field', field)
        $.each(field.types, function(j, type) {

            if(type == "street_number"){
                street_1 = field.long_name
            }
            else if(type == "route"){
                street_1 += " " + field.long_name

            }
            else if (type=="administrative_area_level_2"){
                street_2 = field.long_name
            }

            else if (type == "administrative_area_level_1"){
                state = field.short_name
            }

            else if (type == "locality") {
                city = field.long_name
            }

            else if (type == "postal_code") {
                zip = field.long_name
            }
        })
    })
    console.log(street_1, street_2, state, city, zip)

    setAddressInputFields(street_1, street_2, state, city, zip)


}


function setAddressInputFields(s1, s2, state, city, zip){
    $('#street-1').val(s1);
    $('#street-2').val(s2);
    $('#state').val(state);
    $('#city').val(city);
    $('#zip').val(zip);
}

// Initialize Google Map for looking at existing requests
function initIndexPostsMap() {

    var pitt = {lat: 40.4415031, lng: -80.0096409};

    map = new google.maps.Map(document.getElementById('map'), {
        zoom: 13,
        center: pitt
    });
}



$(function loadJSON(){
    $.ajax({
        type: 'GET',
        url: "/posts.json",
        success: updateMarkers
    });
});

function updateMarkers(posts) {

        var location;
        $.each(posts, function(i, post){
            $.each(post, function(j, indPost){
                location = {lat: indPost.latitude, lng: indPost.longitude}
                console.log(location)
                addMarker(indPost)
            });
        });
}

// Add a marker to the map and push to the array
function addMarker(post) {

    var needs = ''

    $.each(post.post_needs, function(i, post_need){
        needs += '<li>' + post_need.need + '</li>'
    })




    var contentString =
        '<div class="col-lg-12">' +
            '<table class="table">' +
                '<thead>' +
                    '<th>Request posted by ' + post.poster + '</th>' +
        '       </thead>' +

                '<tr>' +
                    '<th>Status:</th>' +
                    '<td>' + `${post.claimer_id == null ? 'Open' : 'Claimed'}` + '</td>' +
                '</tr>' +

                '<tr>' +
                    '<td><b>Address:</b></td>' +
                    '<td>'+ post.street_1 + '</br>'+ post.street_2 + '</br>' + post.city + ', ' + post.state + ' ' + post.zip +
                    '</td>' +
                '</tr>' +
                '<tr>' +
                    '<th> Number of People: </th>' +
                        '<td>' + post.number_people + '</td>' +
                '</tr>' +

                '<tr>' +
                    '<td><b>Needs:</b></td>' +

                    '<td>' + needs + '</td>' +
                '</tr>' +

            '</table>' +
                '<button type="button" class="btn btn-primary">Claim</button>' +

        '</div>'


    var location;
    location = {lat: post.latitude, lng: post.longitude}

    var marker = new google.maps.Marker({
        position: location,
        map: map
    });

    marker.addListener('click', function() {
        infowindow.open(map,marker);
    })
    markers.push(marker);

    var infowindow = new google.maps.InfoWindow({
        content: contentString
    });


}

//Sets the map on all markers in the array.
function setMapOnAll(map) {
    for (var i = 0; i < markers.length; i++){
        markers[i].setMap(map);
    }
}

//Removes the markers from the map, but keeps them in the array
function clearMarkers() {
    setMapOnAll(null);
}

//Shows any markers currently in the array
function showMarkers() {
    setMapOnAll(map);
}

function deleteMarkers() {
    clearMarkers();
    markers = [];
}