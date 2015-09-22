class FeedController < ApplicationController
  def index
    if session[:access_token].nil?
      #redirect_to oauth_path
    end
  end

  def search
    @tag = params[:search]
    if !@tag.empty?
      redirect_to feed_path(@tag)
    else
      redirect_to root_path
    end
    
  end

  def view
    # Get the list of recent urls
    @hashtag = params[:hashtag]

    # @client = Instagram.client(:access_token => session[:access_token])
    @client = Instagram.client
    @tags = @client.tag_search(@hashtag)
  end
  
end
