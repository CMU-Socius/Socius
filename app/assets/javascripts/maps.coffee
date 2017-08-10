## Place all the behaviors and hooks related to the matching controller here.
## All this logic will automatically be available in application.js.
## You can use CoffeeScript in this file: http://coffeescript.org/
#
##
class GoogleMap
  # defaults
  zoom =
    initialView: 15
    closeView: 18
  markers = []
  map = undefined

  constructor: (home) ->
# set map center and view options
#    lat = home["lat"]
#    lon = home["lon"]
    lat = 40.4415031
    lon = -80.0096409
    myLatLng = new google.maps.LatLng(lat, lon)
    console.log('mll', myLatLng)
    mapOptions =
      zoom: zoom.initialView
      center: myLatLng

    # create map
    map = new google.maps.Map(document.getElementById("map"), mapOptions)
    marker = new google.maps.Marker(
      position: new google.maps.LatLng(40,4415031, -80.0096409),
      title: 'draggable marker',
      visible: true)

    marker.setMap(map)

    # Place a draggable marker on the map

  addDraggableMarker: (map) ->
  #create draggable marker to get lat. ln. information to add to db
    marker = new google.maps.Marker(
      position: new google.maps.LatLng(40.4415031,-80.0096409),
      map: map,
      draggable: true,
      title: "Drag me!"
    )

    markers.push marker


  addMarker: (location, title) ->
  # create marker and add it to the array of markers
    console.log('adding marker')
    marker = new google.maps.Marker(
      position: location,
      title: title,
      map: map
    )
    markers.push marker
    console.log('map', map)
    console.log(markers)

    # add event listener - change zoom and center position on marker click
    google.maps.event.addListener marker, "click", ->
      map.setZoom zoom.closeView
      map.setCenter marker.getPosition()

  addMarkers: (markerList) ->
  # add all markers
    _.each markerList, (marker) =>
      position = new google.maps.LatLng marker["lat"], marker["lon"]
      title = "#{marker['full_address']}"
      @addMarker position, title

  drawMarkers: (map) ->
  # draw markers
    _.each markers, (marker) ->
      marker.setMap map
  # IMPORTANT: calling setMap method on marker will draw this marker, calling setMap with null parameter will erase it

  showMarkers: ->
    @setAllMap map

  hideMarkers: ->
    @setAllMap null

  removeListeners: ->
    _.each markers, (marker) ->
      google.maps.event.clearInstanceListeners(marker)

  deleteMarkers: ->
    @hideMarkers()
    @removeListeners()
    markers = []



$ ->


  googleMap = new GoogleMap($('[data-map]').data('home'))
  googleMap.addMarker({lat: 40,4415031, lng:  -80.0096409}, "hi")
  googleMap.drawMarkers($("[data-map]").data("markers-list"))

  $(document).on "click", "[data-tab]", ->
    googleMap.deleteMarkers()
    googleMap.drawMarkers($("[data-map]:eq($(@).index())").data("markers-list"))


  $(document).on 'click', '[data-tab]', ->
    googleMap.deleteMarkers()
    googleMap.drawMarkers($("[data-map]:eq($(@).index())").data("markers-list"))