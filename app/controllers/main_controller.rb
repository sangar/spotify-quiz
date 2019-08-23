class MainController < ApplicationController
  #before_action :authenticate_user!, except: [:login]

  def login
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
