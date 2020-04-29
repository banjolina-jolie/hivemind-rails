require 'sidekiq/web'


Rails.application.routes.draw do
  devise_for :users
  mount Sidekiq::Web => '/sidekiq'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get 'question/:question_id' => 'question#show'

end
