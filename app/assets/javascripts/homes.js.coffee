# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

root = this
module = window.PG ||= {}
$ = jQuery

root.MME = do ( module, $ ) ->
  self = module.utils = module.utils || {}

  self.init = =>
    console.log 'init'

    centerLatLng = new google.maps.LatLng -34.397, 150.644

    mapOptions =
      center: centerLatLng
      zoom: 8
      mapTypeId: google.maps.MapTypeId.ROADMAP # ROADMAP, SATELLITE, HYBRID, TERRAIN

    @map = new google.maps.Map $("#map-canvas").get(0), mapOptions

    @geocoder = new google.maps.Geocoder()

    @infowindow = null

    @houses = []

    google.maps.event.addListener @map, 'idle', addRandomHouses

    # TODO:
    # houses = [
    #   lat: -34.397
    #   lng: 150.644
    #   rating: 0
    # ,
    #   lat: -34.497
    #   lng: 150.544
    #   rating: 85
    # ,
    #   lat: -34.597
    #   lng: 150.344
    #   rating: 150
    # ]
    # addRealHouses houses

    console.log @houses

    google.maps.event.addListener @map, 'click', =>
      @infowindow.close() if @infowindow

    $(document).on 'submit', '#frmAddress', ( e ) ->
      e.preventDefault()
      console.log 'submit'
      codeAddress()

    codeAddress()

  self.openInfoWindow = ( house ) ->
    @infowindow = new google.maps.InfoWindow content: house.markerContent
    @infowindow.open @map, house.g.marker

  # Private

  addHouseMarker = ( house ) ->
    house.g = {}

    house.g.latLng = new google.maps.LatLng house.lat, house.lng

    house.g.marker = new google.maps.Marker
      icon: getIconFromRating house.rating
      position: house.g.latLng
      title: "ER #{ house.rating }"

    house.g.marker.setMap @map

    house.markerContent = """
      <div class="marker-content">
        <img src='/assets/house-preview.png'/>
        <h1>ER #{ house.rating }</h1>
      </div>
    """

    google.maps.event.addListener house.g.marker, 'click', =>
      @infowindow.close() if @infowindow
      @infowindow = new google.maps.InfoWindow content: house.markerContent
      @infowindow.open @map, house.g.marker

    @houses.push house

  addRandomHouses = ( num = 3 ) =>
    llBounds = @map.getBounds()

    console.log 'llBounds', llBounds

    ne = llBounds.getNorthEast()
    sw = llBounds.getSouthWest()

    num.times ->
      rnd1 = Math.random()
      rnd2 = Math.random()

      rndLat = ne.lat() - ((ne.lat() - sw.lat()) * rnd1)
      rndLng = ne.lng() + ((sw.lng() - ne.lng()) * rnd2)

      randMarker = [rndLat, rndLng]

      console.log 'random', randMarker

      addHouseMarker
        lat: rndLat
        lng: rndLng
        rating: Math.floor(Math.random() * 200)

  addRealHouses = ( houses ) ->
    $.map houses, ( house, i ) ->
      addHouseMarker house

  codeAddress = ->
    address = $.trim $('#q').val()

    if !!address
      @geocoder.geocode address: address, ( results, status ) ->
        if status == google.maps.GeocoderStatus.OK
          @map.setCenter results[0].geometry.location
          addRandomHouses()
        else
          alert "Address not found: #{ status }"

  getIconFromRating = ( rating ) ->
    icon = switch
      when rating <= 65 then '/assets/home-green.png'
      when rating <= 100 then '/assets/home-yellow.png'
      else '/assets/home-red.png'

  module

Number::times = (fn) ->
  do fn for [1..@valueOf()]
  return