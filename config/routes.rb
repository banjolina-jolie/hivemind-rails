require 'sidekiq/web'


Rails.application.routes.draw do
  post 'auth-user' => 'authentication#authenticate_user'
  get 'me' => 'me#show'
  get 'home' => 'home#show'

  post 'question' => 'question#create'
  put 'question/:question_id' => 'question#update'
  get 'question/:question_id' => 'question#show'

  mount Sidekiq::Web => '/sidekiq'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
