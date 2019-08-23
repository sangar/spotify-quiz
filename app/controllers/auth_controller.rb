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

    redirect_to playlist_path
  end
end