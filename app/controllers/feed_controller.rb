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
