class HomeController < ApplicationController
  def index
    # this is if we want to do oauth
    # if session[:access_token].nil?
      # redirect_to oauth_path
    # end
  end
end
