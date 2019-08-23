class ApplicationController < ActionController::Base
  def spotify_user
    @spotify_user ||= RSpotify::User.new(session[:spotify_user])
  end
end
