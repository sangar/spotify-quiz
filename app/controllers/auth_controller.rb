class AuthController < ApplicationController
  def callback
    code = params[:code]

    res = HTTParty.post("https://accounts.spotify.com/api/token",
      headers: {
        'Authorization': "Basic #{Base64.urlsafe_encode64("#{ENV['SPOTIFY_CLIENT_ID']}:#{ENV['SPOTIFY_CLIENT_SECRET']}")}"
      }, body: {
        "grant_type" => "authorization_code",
        "code" => code,
        "redirect_uri" => "#{root_url}callback"
      }
    )

    if res['error'].present?
      redirect_to root_path
      return
    end

    access_token = res.parsed_response['access_token']
    refresh_token = res.parsed_response['refresh_token']
    expires_in = res.parsed_response['expires_in']

    res2 = HTTParty.get("https://api.spotify.com/v1/me",
                   headers: {
                     'Authorization': "Bearer #{access_token}"
                   })

    if res2['error'].present?
      redirect_to root_path
      return
    end

    session[:spotify_user] = res2.parsed_response
    session[:spotify_user]['credentials'] = {
      "token" => access_token,
      "refresh_token" => refresh_token,
      "exspires_at" => DateTime.now.to_i + expires_in
    }

    redirect_to playlist_path
  end
end