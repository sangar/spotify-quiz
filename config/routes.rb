Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  #
  get '/auth/spotify/callback', to: 'users/omniauth_callbacks#spotify'
  get 'main/login'
  get 'main/playlist'
  get 'main/start'
  get 'main/quiz'
  get 'main/summary'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'main#login'
end
