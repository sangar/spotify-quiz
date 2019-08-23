Rails.application.routes.draw do
  get 'login', to: 'main#login'
  get 'playlist', to: 'main#playlist'
  get 'start', to: 'main#start'
  get 'quiz', to: 'main#quiz'
  get 'summary', to: 'main#summary'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'main#login'
end
