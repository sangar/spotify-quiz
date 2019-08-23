Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  #
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  get '/auth/spotify/callback', to: 'users/omniauth_callbacks#spotify'
  get 'login', to: 'main#login'
  get 'playlist', to: 'main#playlist'
  get 'start', to: 'main#start'
  get 'quiz', to: 'main#quiz'
  get 'summary', to: 'main#summary'

  root 'main#login'
end
