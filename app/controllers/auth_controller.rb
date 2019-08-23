#!/bin/ruby

class AuthController < ApplicationController
  def callback
    Rails.logger.debug ">>>>>>>>>>>>> callback: #{params}"

    # {
    #   "code"=>"AQBfOmtSv5fgwFKWTPzn4uK7ken4MAwlUcFCvWR0feqrPjBOJi2dHwlQNCG_lR2zl5HTblkIDpsBRFRxK9gi59Txba2Lzm_4AqsOlTqqufbpSt7DugTx_TG8-1XRbadN6tl5wqe5PlNxVghTqobVAeyHAQRi4Yl-zoZJlj_VsNZJhgFmyU7MTwB7iadwCEugOJ-AFpt6xaK9IKGfnQXn0WWquyA4uD8_aTP_cG8Bt0GGOg1Flm_Zr3yyBVOi7S20FxfwHnupUWupemYt4nzmtqAasDCQocrxKAAEmamq2mWNHKqNWa6aObnCrmFtPCVna3N_Q5Buo5kZQfrDH3AbXaYslNx_sJ-PXr5mieSpWnLHhSHbu__V",
    #   "controller"=>"auth", "action"=>"callback"}

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

    # {"access_token"=>"BQBWjwfmHLeEHSnE_5GD6sX9O4j5c9TZo--cTpV3IpOk8fFn_lSvnOvrQVuUJp8SoVVC74gP7yqTUB6XT7uIEt37bgJgr_W0_IMcOUMj1eD4fyOi9WULX4B7tWrWp1mt0dSRuLDo-Q8yfW64hA6FgdIpdsvg6upK4aH7ERkBKBHfse4h4XG-FuxtzL3HWUm8yzsoNnBmZIhq9yQG41Vh2WHRyQfqfoCjB3Luy2PNjA", "token_type"=>"Bearer", "expires_in"=>3600, "refresh_token"=>"AQC0EeHL3MwozUiOyA3mYYAJmEjjXdL9-8uE6Dc5feemwQtGkitCMS3i8MkeklnNwE-3CqepX1j83ZzxUNhijeXgYeim5gu1-3e5VZAvORBTABCbPI9Rxnwoh3VNVdeYZFM0WA", "scope"=>"playlist-read-private user-library-read user-library-modify playlist-modify-private playlist-modify-public user-read-email"}

    Rails.logger.debug ">>>>>>>>>> res.token: #{res.inspect}"

    session[:access_token] = res.parsed_response['access_token']
    session[:refresh_token] = res.parsed_response['refresh_token']

    res2 = HTTParty.get("https://api.spotify.com/v1/me",
                   headers: {
                     'Authorization': "Bearer #{session[:access_token]}"
                   })

    Rails.logger.debug ">>>>>>>>>> res2.token: #{res2.inspect}"

    # {"display_name":"garsan","email":"gard.sandholt@gmail.com","external_urls":{"spotify":"https://open.spotify.com/user/garsan"},"followers":{"href":null,"total":36},"href":"https://api.spotify.com/v1/users/garsan","id":"garsan","images":[],"type":"user","uri":"spotify:user:garsan"}

    session[:spotify_user] = res2.parsed_response
    session[:spotify_user]['credentials'] = {
      "token" => res.parsed_response['access_token'],
      "refresh_token" => res.parsed_response['refresh_token'],
      "exspires_at" => DateTime.now.to_i + res.parsed_response['expires_in']
    }

    redirect_to playlist_path
  end
end