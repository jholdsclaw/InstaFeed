# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  # Start slideshow only if we're on the feed page
  startSlideShow() if $('#slideshow').length
  return

startSlideShow = ->
  # Get our image divs
  divs = $(".image")
  
  current = 0

  nextMedia = ->
    $(divs[current])
      .fadeOut(300)
    $(divs[current = ++current % divs.length])
      .fadeIn(300)
    setTimeout nextMedia, 8000
    return

  nextMedia()
  return
