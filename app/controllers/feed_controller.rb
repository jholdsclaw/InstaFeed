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
    # This is if we wanted to do an oauth lookup
    # @client = Instagram.client(:access_token => session[:access_token])
    # @tags = @client.tag_search(@hashtag)

    # Perform a search for this hash_tag
    @tags = Instagram.tag_search(@hashtag)
    
    logger.debug(@tags.inspect)
    
    # Get recent media using the first tag search results (first result will be exact or closest match if no exact)
    media = Instagram.tag_recent_media(@tags[0].name)
    
    @first_id = media.first.id
    @last_id = media.last.id
    
    @media_urls = media.collect { |m| m.images.standard_resolution.url }
  end
  
end
