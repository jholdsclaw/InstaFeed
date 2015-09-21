class OauthController < ApplicationController
  if ENV['RAILS_ENV'].to_s == 'production' || ENV['RAILS_ENV'].to_s == ''
    CALLBACK_URL = "http://instafeed.jholdsclaw.com/oauth/callback"
  else
    CALLBACK_URL = "http://localhost:3000/oauth/callback"
  end

  def connect
    redirect_to Instagram.authorize_url(:redirect_uri => CALLBACK_URL)
  end

  def callback
    response = Instagram.get_access_token(params[:code], :redirect_uri => CALLBACK_URL)
    session[:access_token] = response.access_token
    redirect_to root_path
  end
end
