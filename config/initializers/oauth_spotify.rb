# require 'rspotify/oauth'
#
# Rails.application.config.to_prepare do
#   OmniAuth::Strategies::Spotify.include SpotifyOmniauthExtension
# end
#
# RSpotify::authenticate(ENV["SPOTIFY_CLIENT_ID"], ENV["SPOTIFY_SECRET_ID"])
#
# Rails.application.config.middleware.use OmniAuth::Builder do
#   provider :spotify, ENV["SPOTIFY_CLIENT_ID"], ENV["SPOTIFY_SECRET_ID"],
#            scope: 'user-read-email playlist-modify-public playlist-modify-private playlist-read-private user-library-read user-library-modify'
# end
