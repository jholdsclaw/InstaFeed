class FeedController < ApplicationController
  def index
    
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
  end
  
end
