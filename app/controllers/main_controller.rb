class MainController < ApplicationController
  before_action :authenticate, except: [:login]

  def login
    redirect_to playlist_path if logged_in?
  end

  def logout
    logout!
  end

  def playlist
    @playlists = spotify_user.playlists
  end

  def start
  end

  def quiz
  end

  def summary
  end
end
