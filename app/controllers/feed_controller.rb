class FeedController < ApplicationController
  def search
    @tag = params[:search]
    if !@tag.empty?
      redirect_to feed_path(@tag)
    else
      redirect_to root_path
    end
    
  end

  def view
    @hashtag = params[:hashtag]

      # Perform a search for this hash_tag
      @tags = Instagram.tag_search(@hashtag)
      
      # Check if we got at least one hit for a tag
      @no_media = (@tags.count == 0)
      # And then check if it's an exact match (only doing exact matches for now)
      @no_media = @no_media || (@tags[0].name != @hashtag)
      # And finally exit if we didn't get a match
      return if @no_media
        
    # This is if we wanted to do an oauth lookup
    # @client = Instagram.client(:access_token => session[:access_token])
    # @tags = @client.tag_search(@hashtag)

    # Get recent media using the first tag search results (first result will be exact or closest match if no exact)
    response = Instagram.tag_recent_media(@tags[0].name) 
    @media = [].concat(response)
    
    max_tag_id = response.pagination.next_max_tag_id
    until max_tag_id.to_s.empty? do
      response = Instagram.tag_recent_media(@tags[0].name, :max_tag_id => max_tag_id)
      max_tag_id = response.pagination.next_max_tag_id
      @media.concat(response)
    end
  end
end
