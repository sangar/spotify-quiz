class ApplicationController < ActionController::Base

  helper_method :logged_in?

  def logged_in?
    session[:spotify_user]
  end

  def authenticate
    redirect_to login_path unless logged_in?
  end

  def logout!
    session[:spotify_user] = nil
    redirect_to root_path
  end

  def spotify_user
    @spotify_user ||= RSpotify::User.new(session[:spotify_user])
  end
end
