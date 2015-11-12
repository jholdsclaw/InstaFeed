class FeedController < ApplicationController

  # This is if we wanted to do an oauth lookup
  # @client = Instagram.client(:access_token => session[:access_token])
  # @tags = @client.tag_search(@hashtag)
  def search
    tag = params[:search]
    if !tag.empty?
      redirect_to feed_path(tag)
    else
      redirect_to root_path
    end # if !tag.empty?
    
  end # def search


  # For the view, we want to start by checking if any images exist in our database,
  # and if so, we'll grab the first one and display it immediately while firing
  # off the background process to grab any new images from Instagram. If no existing
  # media is found, we go ahead and grab the first (up to) 20 images from Instagram
  # and store those, then display the first one while firing off the background process
  # to pull remaining images.
  def view
    # We're going to only store downcase
    tag = params[:hashtag].downcase
    
    # Let's be optimistic...
    @no_media = false
    
    if tag == "jhinstafeed1"
      ######################################
      # All of this is crap for my wedding #
      ######################################
      # start with first picture in server pics
      @media_type = "jh"
      @hashtag = tag
      @media_id = JhMedium.first.id
      @starting_url = JhMedium.first.url_fullsize
    else
      
      # check if we have any existing tags
      hashtag = Hashtag.find_by hashtag: tag
      media = hashtag.media.first unless hashtag.blank?
      
      # if no existing media, let's try to fetch media from Instangram
      if media.blank? 
  
        # Perform a search for this hash_tag
        tags = Instagram.tag_search(tag)
  
        # Check if we got at least one hit for a tag
        @no_media = (tags.count == 0)
  
        # And then check if it's an exact match (only doing exact matches for now)
        @no_media = @no_media || (tags[0].name != tag)
  
        # Only try to fetch media if we found a matching tag
        unless @no_media
          # We've got a hit, let's create our new hashtag entry
          response = Instagram.tag_recent_media(tags[0].name) 
          hashtag = Hashtag.create do |ht|
            ht.hashtag    = tag
            ht.min_tag_id = response.pagination.min_tag_id
            ht.max_tag_id = response.pagination.max_tag_id
          end # Hashtag.create do   
          
          # Now lets create all of the images returned
          response.each do |m|
            medium = hashtag.media.create do |n_m|
              n_m.media_id      = m.id
              n_m.caption       = m.caption.text
              n_m.url_thumbnail = m.images.low_resolution.url
              n_m.url_fullsize  = m.images.standard_resolution.url
            end # hashtag.media.create do
          end # response.each do
        end # unless @no_media
      end # if media.blank?
  
      # Unless we have no media, let's fire off the background process and get the view going with the starting url
      unless @no_media
        # Fire off our background process to get all the rest of the pictures
        # TODO: need to make background processing work
        # HashtagSearcherJob.perform_later(hashtag) 
    
        # Get our starting picture url for the view
        @type_type = "ig"
        @media_id = hashtag.media.first.media_id
        @hashtag = tag
        @starting_url = hashtag.media.first.url_fullsize 
      end # unless @no_media
    end # if tag == "jhinstafeed1"
  end # def view
  
  def fetch
    media_id = params[:media_id]
    tag = params[:hashtag]
    mtype = params[:type]
    
    if mtype == "jh"
      # get the next media      
      @next_media = JhMedium.find(media_id).next
      
      # if the next_media is nil, that means we're at end and need to switch to the InstaGram media
      if @next_media.nil?

        # check if we have any existing tags
        hashtag = Hashtag.find_by(hashtag: tag)
        if hashtag.blank?
          # need to create new hashtag
          response = Instagram.tag_recent_media(tag) 
          
          hashtag = Hashtag.create do |ht|
            ht.hashtag    = tag
            
            max_tag_id = response.pagination.next_max_tag_id
            ht.min_tag_id = response.pagination.min_tag_id
            ht.max_tag_id = response.pagination.next_max_tag_id
            
            # Now lets create all of the images returned
            response.each do |m|
              medium = hashtag.media.create do |n_m|
                n_m.media_id      = m.id
                n_m.caption       = m.caption.text
                n_m.url_thumbnail = m.images.low_resolution.url
                n_m.url_fullsize  = m.images.standard_resolution.url
              end # hashtag.media.create do
            end # response.each do

            until max_tag_id.to_s.empty? do
              response = Instagram.tag_recent_media(@tags[0].name, :max_tag_id => max_tag_id)
              response.each do |m|
                medium = hashtag.media.create do |n_m|
                  n_m.media_id      = m.id
                  n_m.caption       = m.caption.text
                  n_m.url_thumbnail = m.images.low_resolution.url
                  n_m.url_fullsize  = m.images.standard_resolution.url
                end # hashtag.media.create do
              end # response.each do
              ht.max_tag_id = response.pagination.next_max_tag_id
              max_tag_id = response.pagination.next_max_tag_id
            end
            
            
          end # Hashtag.create do   
        end
      end
    else
      # get the next media      
      @next_media = Hashtag.find_by(hashtag: hashtag).media.find_by(media_id: media_id).next
      
      # if the next_media is nil, that means we're at end and need to switch to the server media
      @next_media = JhMedium.first if @next_media.nil?
    end
    
    
    
  end # def fetch
end # class FeedController
