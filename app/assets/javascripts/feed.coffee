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
  
  idx = 0

  nextMedia = ->
    current = $(divs[idx])
    next = $(divs[idx = ++idx % divs.length])
    
    aspectRatio = next.width() / next.height()
    
    # set height/width to fullscreen based on if it's landscape or portrait
    if aspectRatio > 1
      next.css
        height: "100%"
    else
      next.css
        width: "100%"

    current
      .fadeOut(400)
    next
      .fadeIn(400)
    setTimeout nextMedia, 6000
    return

  nextMedia()
  return
