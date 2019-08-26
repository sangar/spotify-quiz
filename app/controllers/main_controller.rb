class MainController < ApplicationController
  #before_action :authenticate_user!, except: [:login]

  def login
  end

  def playlist
    @playlists = spotify_user.playlists
  end

  def start
    @tracks = RSpotify::Playlist.find(spotify_user.id, params[:pid]).tracks
    @devices = spotify_user.devices
    #spotify_user.player.play_context(params[:pid])
  end

  def quiz
  end

  def summary
  end
end
