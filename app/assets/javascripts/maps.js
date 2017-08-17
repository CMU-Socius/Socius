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

    var contentString = '<div class="col-lg-12">' +
        '<table class="table">' +
        '<thead>' +
        '<th>Request posted by ' + post.poster + '</th>' +
        '</thead>' +

        '<tr>' +
        '<th>Status:</th>' +
    '<td>' + 'Open' +
    // <% if object.claimer_id.nil? %>
    // Open
    // <% else %>
    // Claimed
    // <%end%>
    '</td>' +
    '</tr>' +

    '<tr>' +
    '<td><b>Address:</b></td>' +
    '<td>'+ post.street_1 +
        '</br>'
//         <%if !object.street_2.nil?%>
// <%=object.street_2%>
        + post.street_2 +
    '</br>' +
    // <%end%>
     post.city + ', ' + post.state + ' ' + post.zip +
    // <%=object.state%> <%=object.zip%>
        '</td>'
        '</tr>' +

//         <tr>
//         <th> Number of People: </th>
//     <td> <%= object.number_people %> </td>
//         </tr>
//
//         <tr>
//         <td><b>Needs:</b></td>
//     <% needs = object.post_needs.map{|p| p.need.name} %>
// <td>
//     <% needs.each do |n| %>
//     <li><%= n %></li>
//         <%end %>
//         </td>

        '</table>' +

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