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
    end
    
  end


  def view
    tag = params[:hashtag].downcase
    
    # When going to view, start with first image url to so user isn't waiting for AJAX call for first image
    
    # check if we have any existing tags
    existing_hashtag = Hashtag.find_by hashtag: tag
    existing_media = existing_hashtag.media unless existing_hashtag.blank?
    
    unless existing_media.blank? 
      # already have some media, so let's just fire off the background process...
      # HashtagSearcher.perform_async(tag)
      
      # And set our first media to start with
      @first_media = existing_media.first
      @no_medial = false
    else # if no existing tags, let's try to fetch media from Instangram

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
        end       
        
        response.each do |m|
          medium = hashtag.media.create do |n_m|
            n_m.media_id      = m.id
            n_m.caption       = m.caption.text
            n_m.url_thumbnail = m.images.low_resolution.url
            n_m.url_fullsize  = m.images.standard_resolution.url
          end
          # store the first result
          @first_media ||= medium
        end
        
=begin
          # check for older photos - check against max_tag_id
          # check for newer photos - check against min_tag_id
          
          max_tag_id = response.pagination.next_max_tag_id
          until max_tag_id.to_s.empty? do
            response = Instagram.tag_recent_media(@tags[0].name, :max_tag_id => max_tag_id)
            max_tag_id = response.pagination.next_max_tag_id
            @media.concat(response)
          end
=end
      end
    end

    @hashtag      = tag
    @starting_url = @first_media.url_fullsize unless @first_media.blank? 
    
    # 2.a only trigger background if there are more than 20 recent exist
  end
end
