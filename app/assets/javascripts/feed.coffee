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
  

  # grab our starting img
  starting_pic = $(divs[0])
  
  aspectRatio = starting_pic.width() / starting_pic.height()
  
  # set height/width to fullscreen based on if it's landscape or portrait
  if aspectRatio > 1
    starting_pic.css
      height: "100%"
  else
    starting_pic.css
      width: "100%"
  
  # display our starting pic
  starting_pic
    .fadeIn(400)

  # main loop to get cycle through the rest
  idx = 0
  nextMedia = ->
    current = $(divs[idx])
    next = $(divs[idx = ++idx % divs.length])
    
    # load next image via AJAX
    $.ajax
      type: "POST"
      url: "media/next"
      dataType: "json"
      data : 
        type: current.data("mtype")
        hashtag: current.data("hashtag")
        media_id: current.attr("id")
      error: (response, status, error) ->
        # do some errorchecking?
        console.log(error)
        return
      success: (data, status, response) ->
        console.log(data)
        next.attr("id", data.media_id)
        next.data("mtype", data.media_type) 
        next.data("hashtag", data.hashtag) 
        next.css("background-image", "url(" + data.url + ")")
        return
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
