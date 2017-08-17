// Called by google maps API when main script finishes loading
var map;
var marker;
var markers = [];





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

    google.maps.event.addListener(marker, 'dragend', function(evt){
        document.getElementById('current').innerHTML = '<p>Marker dropped: Current Lat: ' + evt.latLng.lat().toFixed(3) + ' Current Lng: ' + evt.latLng.lng().toFixed(3) + '</p>';
        console.log('dragging')
    });

    google.maps.event.addListener(marker, 'dragstart', function(evt){
        document.getElementById('current'),innerHTML = '<p>Currently dragging marker...</p>';
    });

    map.setCenter(marker.position);
    marker.setMap(map);


}

// function loadJSON(callback) {
//
//     var url = "http://localhost:3000/posts.json";
//
//     var dataRequest = new XMLHttpRequest();
//
//
//
//     dataRequest.onreadystatechange = function() {
//         if (dataRequest.readyState == 4 && dataRequest.status == "200") {
//             callback(dataRequest.responseText);
//         }
//     };
//
//     dataRequest.open('GET', url, true);
//
//     dataRequest.send();
// }


function initIndexPostsMap() {

    //how to get this json file when it's no longer localhost

    // loadJSON(function(response){
    //     var actual_JSON = JSON.parse(response)
    //     console.log("inner aj", actual_JSON)
    //     return actual_JSON
    // });


    var pitt = {lat: 40.4415031, lng: -80.0096409};

    map = new google.maps.Map(document.getElementById('map'), {
        zoom: 15,
        center: pitt
    });

    // $(postData.posts).each(function (i){
    //     var location = {lat: postData.posts[i].latitude, lng: postData.posts[i].longitude}
    //     addMarker(location)
    // })



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
                addMarker(location)
            });
        });
}



// Add a marker to the map and push to the array
function addMarker(location) {
    var marker = new google.maps.Marker({
        position: location,
        map: map
    });
    markers.push(marker);
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