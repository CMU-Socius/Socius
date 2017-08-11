var nMap;

function initialize() {

    var myLatlng = new google.maps.LatLng(40.4415031, -80.0096409);
    var mapOptions = {
        zoom: 15,
        center: myLatlng
    };


    nMap = new google.maps.Map(document.getElementById('nMap'), mapOptions);

    var marker = new google.maps.Marker({
        position: myLatlng,
        title: "Hello World!",
        draggable: true
    });

    marker.setMap(nMap);
}

google.maps.event.addDomListener(window, 'load', initialize);