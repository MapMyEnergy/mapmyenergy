# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

root = this
module = window.PG ||= {}
$ = jQuery

root.MME = do ( module, $ ) ->
  self = module.utils = module.utils || {}

  self.init = ->
    console.log 'init'
    mapOptions =
      center: new google.maps.LatLng(-34.397, 150.644)
      zoom: 8
      mapTypeId: google.maps.MapTypeId.ROADMAP

    map = new google.maps.Map document.getElementById("map-canvas"),
        mapOptions
  module