Rails.application.routes.draw do
  get 'main/login'
  get 'main/playlist'
  get 'main/start'
  get 'main/quiz'
  get 'main/summary'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'main#login'
end
