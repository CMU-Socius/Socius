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
function initNewPostMap() {
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

    latLngInput = marker.getPosition();
    console.log('initial latlng', latLngInput)

    var geocoder = new google.maps.Geocoder;



    google.maps.event.addListener(marker, 'dragend', function(evt){
        document.getElementById('current').innerHTML = '<p>Marker dropped: Current Lat: ' + evt.latLng.lat().toFixed(3) + ' Current Lng: ' + evt.latLng.lng().toFixed(3) + '</p>';
        lat = evt.latLng.lat()
        latLngInput = {lat: lat, lng: lng}
    });

    google.maps.event.addListener(marker, 'dragstart', function(evt){
        document.getElementById('current'),innerHTML = '<p>Currently dragging marker...</p>';
        lng = evt.latLng.lng()
        latLngInput = {lat: lat, lng: lng}
        geocodeLatLng(geocoder,map, latLngInput)
    });

    map.setCenter(marker.position);
    marker.setMap(map);
    geocodeLatLng(geocoder, map, latLngInput)
    console.log(address)
    fillAddressField()




}

//Reverse geocode
function geocodeLatLng(geocoder, map, latLngInput){
    var input = latLngInput
    geocoder.geocode({'location': input}, function(results, status){
        if (status === 'OK') {
            if(results[0]) {
                address = results[0].formatted_address
                addArray = address.split(',')
            }
        }
    })
}

function fillAddressField() {
    console.log('filling address field', addArray.length, address)
    if(addArray.length == 4) {
        var street_1 = addArray[0];
        var street_2 = addArray[1];
        var city = addArray[2]
        var state = addArray[3].split(' ')
        console.log("state", state)
    }

}


$(document).ready(function(){
    console.log('ready!');
    $('#street_1').val()

});

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